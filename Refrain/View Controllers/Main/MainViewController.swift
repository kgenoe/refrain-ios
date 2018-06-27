//
//  MainViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var tableViewDelegate: MainTableViewDelegate!
    
    
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
        
        // Build TableViewStructure
        let collections = BlockingCollectionStore.shared.collections
        let defaultCount = collections.filter{ $0.isDefault }.count
        let userCount = collections.filter{ !$0.isDefault }.count
        let tableViewStructure = MainTableViewStructure(defaultCollectionsCount: defaultCount, userCollectionsCount: userCount)
        
        // Build TableView Delegate/Datasource
        tableViewDelegate = MainTableViewDelegate(structure: tableViewStructure)
        tableViewDelegate.collectionSelectedHandler = pushBlockingCollectionView
        tableViewDelegate.newCollectionSelectedHandler = presentCreateBlockingCollectionAlert
        tableViewDelegate.schedulesSelectedHandler = pushSchedulesView
        tableViewDelegate.settingsSelectedHandler = pushSettingsView
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        
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
