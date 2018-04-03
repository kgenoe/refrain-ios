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
    
    @IBOutlet weak var filterTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!

    
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
            descriptionTextField.text = rule.ruleDescription
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
            let filter = filterTextField.text ?? ""
            let description = descriptionTextField.text ?? ""
            let newRule = BlockingRule(urlFilter: filter, ruleDescription: description)
            BlockingListStore.shared.saveRule(newRule, to: blockingList)
        }
        
        // return to blocking list
        navigationController?.popViewController(animated: true)
    }
}
