//
//  BlockingRuleViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingRuleViewController: UIViewController {

    var blockingList: BlockingList!
    
    var blockingRule: BlockingRule?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var filterTextField: UITextField!
    
    
    
    static func instantiate(blockingList: BlockingList, blockingRule: BlockingRule? = nil) -> BlockingRuleViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingRuleViewController") as! BlockingRuleViewController
        vc.blockingList = blockingList
        vc.blockingRule = blockingRule
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
        
        
        if let rule = blockingRule {
            navigationItem.title = "Edit Rule"
            nameTextField.text = rule.name
            filterTextField.text = rule.urlFilter
        } else {
            navigationItem.title = "New Rule"
        }
    }
    

    @objc func saveButtonPressed() {
        
        // Do checks on URL filter here
//        guard filter == formatedProperly() else { return }
        
        // Patch existing rule
        if let updatedRule = blockingRule {
            BlockingListStore.shared.saveRule(updatedRule, to: blockingList)
        }
        // Save new rule
        else {
            let name = nameTextField.text ?? ""
            let filter = filterTextField.text ?? ""
            let newRule = BlockingRule(name: name, urlFilter: filter)
            BlockingListStore.shared.saveRule(newRule, to: blockingList)
        }
        
        // return to blocking list
        navigationController?.popViewController(animated: true)
    }
}
