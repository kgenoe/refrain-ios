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
        let lists = BlockingListStore.shared.lists
        let defaultCount = lists.filter{ $0.isDefault }.count
        let userCount = lists.filter{ !$0.isDefault }.count
        return MainTableViewStructure(defaultListsCount: defaultCount, userListsCount: userCount)
    }
    
    
    
    
    // MARK: - Push child view controllers
    
    func pushBlockingListView(list: BlockingList) {
        let blockingListVC = BlockingListViewController.instantiate(blockingList: list)
        navigationController?.pushViewController(blockingListVC, animated: true)
    }
    
    func pushSchedulesView() {
        let schedulesVC = BlockingSchedulesViewController.instantiate()
        navigationController?.pushViewController(schedulesVC, animated: true)
    }
    
    func pushSettingsView() {
        let settingsVC = SettingsViewController.instantiate()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    
    // MARK: - New Blocking List Alert
    var alert: UIAlertController?
    
    private func presentCreateBlockingListAlert() {
        alert = UIAlertController(title: "New Blocking List", message: "Enter a name for the new collection of blocked websites", preferredStyle: .alert)
        
        alert?.addTextField(configurationHandler: nil)
        alert?.textFields?[0].addTarget(self, action: #selector(alertTextDidChange), for: .editingChanged)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert?.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let newList = BlockingList(name: self.alert?.textFields?.first?.text ?? "")
            BlockingListStore.shared.saveList(newList)
            self.pushBlockingListView(list: newList)
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
        case .DefaultBlockingListsHeader:
            return HeaderTableViewCell(title: "Default Lists")
        case .DefaultBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ $0.isDefault }[i]
            return BlockingListCell(blockingList: list)
        case .UserBlockingListsHeader:
            return HeaderTableViewCell(title: "Custom Lists")
        case .UserBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ !$0.isDefault }[i]
            return BlockingListCell(blockingList: list)
        case .NewUserBlockingList:
            let cell = HeaderTableViewCell(title: "New Blocking List")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        case .SchedulesHeader:
            return HeaderTableViewCell(title: "Schedules")
        case .Schedules:
            let cell = HeaderTableViewCell(title: "Schedules")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        case .Settings:
            let cell = HeaderTableViewCell(title: "Settings")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ $0.isDefault }[i]
            self.pushBlockingListView(list: list)
        case .UserBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ !$0.isDefault }[i]
            self.pushBlockingListView(list: list)
        case .NewUserBlockingList:
            self.presentCreateBlockingListAlert()
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
        case .DefaultBlockingLists(_), .UserBlockingLists(_), .NewUserBlockingList, .Schedules, .Settings:
            return indexPath
        default:
            return nil
        }
    }
    
    /// Conditionally enable deletion for user created blocking lists
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableViewStructure.rowType(for: indexPath) {
        case .UserBlockingLists(_): return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle, tableViewStructure.rowType(for: indexPath)) {
        case (.delete, .UserBlockingLists(let i)):
            
            // delete the list in the data store
            let lists = BlockingListStore.shared.lists
            let userCreatedLists = lists.filter{ $0.isDefault == false }
            let listToDelete = userCreatedLists[i]
            BlockingListStore.shared.delete(listToDelete)
            
            // refresh the table view structure
            tableViewStructure = updateTableViewStructure()

            // delete the table view cell
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default: break
        }
    }
}
