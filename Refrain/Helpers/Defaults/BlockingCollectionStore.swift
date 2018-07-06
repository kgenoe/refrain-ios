//
//  BlockingCollectionStore.swift
//  Refrain
//
//  Created by Kyle on 2018-03-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingCollectionStore: NSObject {
    
    static let shared = BlockingCollectionStore()
    
    
    // UserDefaults Keys
    private let collectionStoreKey = "collectionStore"
    private let hasCollectionStoreBeenCreatedKey = "hasCollectionStoreBeenCreated"
    
    private override init() {
        let collectionStoreHasBeenCreated = UserDefaults.standard.bool(forKey: hasCollectionStoreBeenCreatedKey)
        if !collectionStoreHasBeenCreated {
            let data = NSKeyedArchiver.archivedData(withRootObject: [])
            UserDefaults.standard.set(data, forKey: collectionStoreKey)
            UserDefaults.standard.set(true, forKey: hasCollectionStoreBeenCreatedKey)
        }
    }
    
    
    /// An array of all currently stored blocking collections. Repeated calls of collections should be avoided is possible for performance.
    var collections: [BlockingCollection] {
        let data = UserDefaults.standard.data(forKey: collectionStoreKey)!
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [BlockingCollection] ?? []
    }
    
    
    
    
    //MARK: - Saving/Deleting Collection
    /// Saves a BlockingCollection. If the collection already exists in the store, it is replaces with the new collection. Optionally provide an index for where to insert the collection in the store (only works for new collections).
    func saveCollection(_ collection: BlockingCollection, index: Int? = nil) {
        
        var existingCollections = self.collections
        
        // if new collection
        if !existingCollections.contains(where: { $0.id == collection.id }) {
            // if an index is provided, insert there if possible
            if let index = index, existingCollections.count > index {
                existingCollections.insert(collection, at: index)
            } else {
                existingCollections.append(collection)
            }
        }
        
        // else, update existing collection
        else {
            for i in 0..<existingCollections.count {
                let existingCollection = existingCollections[i]
                if existingCollection.id == collection.id {
                    existingCollections[i] = collection
                    break
                }
            }
        }
        
        // Save changed collection to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingCollections)
        UserDefaults.standard.set(data, forKey: collectionStoreKey)
    }
    
    /// Deletes the given collection from the store.
    func delete(_ collection: BlockingCollection) {
        
        var existingCollections = self.collections
        
        for i in 0..<existingCollections.count {
            let existingCollection = existingCollections[i]
            if existingCollection.id == collection.id {
                existingCollections.remove(at: i)
                break
            }
        }
        
        // Save changed collections to defaults
        let data = NSKeyedArchiver.archivedData(withRootObject: existingCollections)
        UserDefaults.standard.set(data, forKey: collectionStoreKey)
    }
    


    //MARK: - Adding/Deleting Rules From A Collection
    /// Saves a BlockingRule to a BlockingCollection and stores the updated BlockingCollection to the store. If the rule already exists in the collection, it replaces it with the new rule. If the collection does not already exist in the store, this function does nothing.
    func saveRule(_ rule: BlockingRule, to collection: BlockingCollection) {
       
        let existingCollections = self.collections
        
        // Ensure the provided collection exists in the store
        guard let existingCollection = existingCollections.first(where: { $0.id == collection.id }) else {
            return
        }
        
        var rules = existingCollection.rules

        // if new rule in collection
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
        
        // Save the updated rule & collection
        existingCollection.rules = rules
        self.saveCollection(existingCollection)
    }
//
//    /// Deletes the rule from the given collection.
//    func deleteRule(_ rule: BlockingRule, from collection: BlockingCollection) {
//        fatalError("deleteRule(_ rule: BlockingRule, from collection: BlockingCollection) - UNIMPLEMENTED")
//    }
}
