//
//  MainViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var tableViewStructure: MainTableViewStructure!

    @IBOutlet private weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
    private func setupView() {
        
        tableViewStructure = updateTableViewStructure()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: false)
        }
        
        // set back button for child views
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        
        tableView.reloadData()
        
        setBackgroundGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBackgroundGradient()
    }
    
    
    private func setBackgroundGradient() {
        view.layer.sublayers?.filter{ ($0 as? BackgroundGradientLayer) != nil }
            .forEach{ $0.removeFromSuperlayer() }
        
        let gradient = BackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradient)
    }
    
    
    private func updateTableViewStructure() -> MainTableViewStructure {
        let collections = BlockingCollectionStore.shared.collections
        let defaultCount = collections.filter{ $0.isDefault }.count
        let userCount = collections.filter{ !$0.isDefault }.count
        return MainTableViewStructure(defaultCollectionsCount: defaultCount, userCollectionsCount: userCount)
    }
    
    
    
    
    // MARK: - Push child view controllers
    
    func pushBlockingCollectionView(collection: BlockingCollection) {
        let blockingCollectionVC = BlockingCollectionViewController.instantiate(blockingCollection: collection)
        navigationController?.pushViewController(blockingCollectionVC, animated: true)
    }
    
    func pushSchedulesView() {
        let schedulesVC = BlockingSchedulesViewController.instantiate()
        navigationController?.pushViewController(schedulesVC, animated: true)
    }
    
    func pushSettingsView() {
        let settingsVC = SettingsViewController.instantiate()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    
    // MARK: - New Blocking Collection Alert
    var alert: UIAlertController?
    
    private func presentCreateBlockingCollectionAlert() {
        alert = UIAlertController(title: "New Blocking Collection", message: "Enter a name for the new collection of blocked websites", preferredStyle: .alert)
        
        alert?.addTextField(configurationHandler: nil)
        alert?.textFields?[0].addTarget(self, action: #selector(alertTextDidChange), for: .editingChanged)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert?.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let newCollection = BlockingCollection(name: self.alert?.textFields?.first?.text ?? "")
            BlockingCollectionStore.shared.saveCollection(newCollection)
            self.pushBlockingCollectionView(collection: newCollection)
        })
        saveAction.isEnabled = false
        saveAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert?.addAction(saveAction)
        
        present(alert!, animated: true, completion: nil)
    }
   
    @objc func alertTextDidChange() {
        guard let alert = alert else { return }
        
        if alert.textFields?[0].text ?? "" == "" {
            alert.actions[1].isEnabled = false
        } else {
            alert.actions[1].isEnabled = true
        }
    }
}



//MARK: - UITableViewDelegate & UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewStructure.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableViewStructure.rowCountFor(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingCollectionsHeader:
            return HeaderTableViewCell(title: "Default Collections")
        case .DefaultBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ $0.isDefault }[i]
            return BlockingCollectionCell(blockingCollection: collection)
        case .UserBlockingCollectionsHeader:
            return HeaderTableViewCell(title: "Custom Collections")
        case .UserBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ !$0.isDefault }[i]
            return BlockingCollectionCell(blockingCollection: collection)
        case .NewUserBlockingCollection:
            let cell = HeaderTableViewCell(title: "New Blocking Collection")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        case .Schedules:
            return ItemTableViewCell(text: "Schedules")
        case .Settings:
            return ItemTableViewCell(text: "Settings")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ $0.isDefault }[i]
            self.pushBlockingCollectionView(collection: collection)
        case .UserBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ !$0.isDefault }[i]
            self.pushBlockingCollectionView(collection: collection)
        case .NewUserBlockingCollection:
            self.presentCreateBlockingCollectionAlert()
        case .Schedules:
            self.pushSchedulesView()
        case .Settings:
            self.pushSettingsView()
        default:
            break
        }
    }
    
    
    /// Conditionally disable selection for some table view rows
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingCollections(_), .UserBlockingCollections(_), .NewUserBlockingCollection, .Schedules, .Settings:
            return indexPath
        default:
            return nil
        }
    }
    
    /// Conditionally enable deletion for user created blocking collections
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableViewStructure.rowType(for: indexPath) {
        case .UserBlockingCollections(_): return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle, tableViewStructure.rowType(for: indexPath)) {
        case (.delete, .UserBlockingCollections(let i)):
            
            // delete the collection in the data store
            let collections = BlockingCollectionStore.shared.collections
            let userCreatedCollections = collections.filter{ $0.isDefault == false }
            let collectionToDelete = userCreatedCollections[i]
            BlockingCollectionStore.shared.delete(collectionToDelete)
            
            // refresh the table view structure
            tableViewStructure = updateTableViewStructure()

            // delete the table view cell
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default: break
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableViewStructure.sectionTypeFor(section) {
        case .Schedules, .Settings: return 40
        default: return 0
        }
    }
}
