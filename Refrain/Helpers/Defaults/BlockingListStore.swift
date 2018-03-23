//
//  BlockingListStore.swift
//  Refrain
//
//  Created by Kyle on 2018-03-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingListStore: NSObject {
    
    static let shared = BlockingListStore()
    
    
    // UserDefaults Keys
    private let listStoreKey = "listStore"
    private let hasListStoreBeenCreatedKey = "hasListStoreBeenCreated"
    
    private override init() {
        let listStoreHasBeenCreated = UserDefaults.standard.bool(forKey: hasListStoreBeenCreatedKey)
        if !listStoreHasBeenCreated {
            let initalBlockingList = BlockingList(name: "Blocking List")
            let data = NSKeyedArchiver.archivedData(withRootObject: [initalBlockingList])
            UserDefaults.standard.set(data, forKey: listStoreKey)
            UserDefaults.standard.set(true, forKey: hasListStoreBeenCreatedKey)
        }
    }
    
    
    /// An array of all currently stored blocking lists. Repeated calls of lists should be avoided is possible for performance.
    var lists: [BlockingList] {
        let data = UserDefaults.standard.data(forKey: listStoreKey)!
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [BlockingList] ?? []
    }
    
    
    
    
    //MARK: - Saving/Deleting Lists
    /// Saves a BlockingList. If the list already exists in the store, it is replaces with the new list.
    func saveList(_ list: BlockingList) {
        
        var existingLists = self.lists
        
        // if new list
        if !existingLists.contains(where: { $0.id == list.id }) {
            existingLists.append(list)
        }
        
        // else, update existing list
        else {
            for i in 0..<existingLists.count {
                let existingList = existingLists[i]
                if existingList.id == list.id {
                    existingLists[i] = list
                    break
                }
            }
        }
        
        // Save changed list to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingLists)
        UserDefaults.standard.set(data, forKey: listStoreKey)
    }
    
    /// Deletes the given list from the store.
    func delete(_ list: BlockingList) {
        
        var existingLists = self.lists
        
        for i in 0..<existingLists.count {
            let existingList = existingLists[i]
            if existingList.id == list.id {
                existingLists.remove(at: i)
                break
            }
        }
        
        // Save changed lists to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingLists)
        UserDefaults.standard.set(data, forKey: listStoreKey)
    }
    


    //MARK: - Adding/Deleting Rules From A List
    /// Saves a BlockingRule to a BlockingList and stores the updated BlockingList to the store. If the rule already exists in the list, it replaces it with the new rule. If the list does not already exist in the store, this function does nothing.
    func saveRule(_ rule: BlockingRule, to list: BlockingList) {
       
        let existingLists = self.lists
        
        // Ensure the provided list exists in the store
        guard let existingList = existingLists.first(where: { $0.id == list.id }) else {
            return
        }
        
        var rules = existingList.rules

        // if new rule in list
        if !rules.contains(where: { $0.createdDate == rule.createdDate }) {
            rules.append(rule)
        }
        //else, update the rule
        for i in 0..<rules.count {
            let existingRule = rules[i]
            if rule.createdDate == existingRule.createdDate {
                rules[i] = rule
                break
            }
        }
        
        // Save the updated rule & list
        existingList.rules = rules
        self.saveList(existingList)
    }
//
//    /// Deletes the rule from the given list.
//    func deleteRule(_ rule: BlockingRule, from list: BlockingList) {
//        fatalError("deleteRule(_ rule: BlockingRule, from list: BlockingList) - UNIMPLEMENTED")
//    }
}
