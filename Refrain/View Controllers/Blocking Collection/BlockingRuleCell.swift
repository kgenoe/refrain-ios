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
        
        super.init(text: blockingRule.urlFilter, accessoryType: .none)
        
        accessorySwitch.isOn = blockingRule.enabled
        accessorySwitch.isEnabled = blockingCollection.enabled
        accessorySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switchToggled() {
        blockingRule.enabled = accessorySwitch.isOn
        BlockingCollectionStore.shared.saveRule(blockingRule, to: blockingCollection)
    }
}
