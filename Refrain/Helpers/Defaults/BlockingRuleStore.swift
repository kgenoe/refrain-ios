//
//  ObjectStore.swift
//  Refrain
//
//  Created by Kyle on 2018-01-24.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingRuleStore: NSObject {
    

    static let shared = BlockingRuleStore()
    
    
    // UserDefaults Keys
    private let ruleStore = "ruleStore"
    private let wasRuleStoreCreated = "wasRuleStoreCreated"
    
    override init() {
        let ruleStoreCreated = UserDefaults.standard.bool(forKey: wasRuleStoreCreated)
        if !ruleStoreCreated {
            let data = NSKeyedArchiver.archivedData(withRootObject: [BlockingRule]())
            UserDefaults.standard.set(data, forKey: ruleStore)
            UserDefaults.standard.set(true, forKey: wasRuleStoreCreated)
        }
    }

  
    /// Saves a new rule. If the rule already exists in the store, it is updated.
    func save(_ newRule: BlockingRule) {
        
        var existingRules = self.rules
        
        // if new rule
        if !existingRules.contains(where: { $0.createdDate == newRule.createdDate }) {
            existingRules.append(newRule)
        }
        // else, update existing rule
        else {
            for i in 0..<existingRules.count {
                let existingRule = existingRules[i]
                if existingRule.createdDate == newRule.createdDate {
                    existingRules[i] = newRule
                    break
                }
            }
        }

        // Save changed rules to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingRules)
        UserDefaults.standard.set(data, forKey: ruleStore)
    }
    
    
    func delete(_ rule: BlockingRule) {
        
        var existingRules = self.rules
        
        for i in 0..<existingRules.count {
            let existingRule = existingRules[i]
            if existingRule.createdDate == rule.createdDate {
                existingRules.remove(at: i)
                break
            }
        }
        
        // Save changed rules to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingRules)
        UserDefaults.standard.set(data, forKey: ruleStore)
    }
    
    /// An array of all currently stored blocking rules. Repeated calls of rules should be avoided if possible for performance.
    var rules: [BlockingRule] {
        let defaults = UserDefaults.standard
        return (NSKeyedUnarchiver.unarchiveObject(with: defaults.data(forKey: ruleStore)!) as? [BlockingRule]) ?? []
    }
}
