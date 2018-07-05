//
//  BlockingRuleCell.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingRuleCell: SwitchTableViewCell {
    
    var blockingCollection: BlockingCollection!

    var blockingRule: BlockingRule!
    
    init(blockingCollection: BlockingCollection, blockingRule: BlockingRule) {
        self.blockingCollection = blockingCollection
        self.blockingRule = blockingRule
        
        super.init()
        enabledSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        setInitialState(for: blockingRule, collection: blockingCollection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setInitialState(for rule: BlockingRule, collection: BlockingCollection) {
        titleLabel.text = rule.urlFilter
        enabledSwitch.isOn = rule.enabled
        enabledSwitch.isEnabled = collection.enabled
    }
    
    @objc func switchToggled() {
        blockingRule.enabled = enabledSwitch.isOn
        BlockingCollectionStore.shared.saveRule(blockingRule, to: blockingCollection)
    }
}
