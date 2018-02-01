//
//  BlockingListViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Blocking Rules"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newBlockingRuleButtonPressed() {
        let newRuleVC = BlockingRuleViewController.instantiate()
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
            let ruleToDelete = BlockingRuleStore.shared.rules[indexPath.row]
            BlockingRuleStore.shared.delete(ruleToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rule = BlockingRuleStore.shared.rules[indexPath.row]
        let editRuleVC = BlockingRuleViewController.instantiate(blockingRule: rule)
        navigationController?.pushViewController(editRuleVC, animated: true)
    }
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlockingRuleStore.shared.rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rule = BlockingRuleStore.shared.rules[indexPath.row]
        return BlockingRuleCell.instantiate(from: tableView, blockingRule: rule)
    }
    
}
