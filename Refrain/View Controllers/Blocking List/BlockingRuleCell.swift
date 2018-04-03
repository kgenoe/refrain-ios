//
//  BlockingRuleCell.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingRuleCell: UITableViewCell {
    
    var blockingList: BlockingList!

    var blockingRule: BlockingRule!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    
    static func instantiate(from tableView: UITableView, blockingList: BlockingList, blockingRule: BlockingRule) -> BlockingRuleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockingRuleCell") as! BlockingRuleCell
        cell.blockingRule = blockingRule
        cell.setInitialState(for: blockingRule)
        return cell
    }
    
    
    private func setInitialState(for rule: BlockingRule) {
        titleLabel.text = rule.urlFilter
        descriptionLabel.text = rule.ruleDescription
        enabledSwitch.isOn = rule.enabled
    }
    
    @IBAction func switchToggled() {
        blockingRule.enabled = enabledSwitch.isOn
        BlockingListStore.shared.saveRule(blockingRule, to: blockingList)
    }
}
