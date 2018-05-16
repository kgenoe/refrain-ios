//
//  ContentBlockerManager.swift
//  Refrain
//
//  Created by Kyle on 2018-04-25.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class ContentBlockerManager: NSObject {
    
    static let shared = ContentBlockerManager()
    
    private override init() { }
    
    
    func update(_ rules: [String]) {
        
        var blockingItems = [[String: Any]]()

        for rule in rules {
            let trigger = ["url-filter": rule]
            let action = ["type" : "block"]
            let item = ["trigger": trigger, "action": action]
            blockingItems.append(item)
        }
        
        print(rules)
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: blockingItems, options: []) else {
            print("Error serializing blocking items into json")
            return
        }
        
        
        // open file
        let fileManager = FileManager.default
        let appGroup = "group.ca.genoe.Refrain"
        guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Error reaching Refrain shared container.")
            return
        }
        
        let path = container.appendingPathComponent("blockerList.json")
        fileManager.createFile(atPath: path.path, contents: jsonData, attributes: nil)
    }
}
