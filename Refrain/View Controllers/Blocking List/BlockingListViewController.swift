//
//  BlockingListViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingListViewController: UIViewController {

    var blockingList: BlockingList!
    
    @IBOutlet weak var tableView: UITableView!
    
    static func instantiate(blockingList: BlockingList) -> BlockingListViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingListViewController") as! BlockingListViewController
        vc.blockingList = blockingList
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // check for updated version of blocking list from store
        if let updatedBlockingList = BlockingListStore.shared.lists.first(where: { $0.id == blockingList.id }) {
            blockingList = updatedBlockingList
        }
        
        navigationItem.title = blockingList.name
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newBlockingRuleButtonPressed() {
        let newRuleVC = BlockingRuleViewController.instantiate(blockingList: blockingList)
        navigationController?.pushViewController(newRuleVC, animated: true)
    }
    
}



extension BlockingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            blockingList.rules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rule = blockingList.rules[indexPath.row]
        let editRuleVC = BlockingRuleViewController.instantiate(blockingList: blockingList, blockingRule: rule)
        navigationController?.pushViewController(editRuleVC, animated: true)
    }
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockingList.rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rule = blockingList.rules[indexPath.row]
        return BlockingRuleCell.instantiate(from: tableView, blockingList: blockingList, blockingRule: rule)
    }
    
}
