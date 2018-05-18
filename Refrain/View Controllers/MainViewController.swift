//
//  MainViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var tableViewStructure: BlockingListsTableViewStructure!

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
        
        let lists = BlockingListStore.shared.lists
        let defaultCount = lists.filter{ $0.isDefault }.count
        let userCount = lists.filter{ !$0.isDefault }.count
        tableViewStructure = BlockingListsTableViewStructure(defaultListsCount: defaultCount, userListsCount: userCount)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: false)
        }
        
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
    
    

    
    @objc func blockingSchedulesCardViewPressed() {
        self.performSegue(withIdentifier: "toBlockingSchedules", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let navVC = segue.destination as? UINavigationController,
            segue.identifier == "toBlockingList" {
            let blockingListVC = BlockingListViewController.instantiate(blockingList: sender as! BlockingList)
            navVC.viewControllers[0] = blockingListVC
        }
    }
}



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
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ $0.isDefault }[i]
            performSegue(withIdentifier: "toBlockingList", sender: list)
        case .UserBlockingLists(let i):
            let list = BlockingListStore.shared.lists.filter{ !$0.isDefault }[i]
            performSegue(withIdentifier: "toBlockingList", sender: list)
        default:
            break
        }
    }
    
    /// Conditionally disable deletion for some table view rows
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingLists(_), .UserBlockingLists(_):
           return .delete
        default:
            return .none
        }
    }
    
    /// Conditionally disable selection for some table view rows
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .DefaultBlockingLists(_), .UserBlockingLists(_):
            return indexPath
        default:
            return nil
        }
    }
}
