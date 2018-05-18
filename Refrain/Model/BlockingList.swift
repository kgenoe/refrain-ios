//
//  BlockingList.swift
//  Refrain
//
//  Created by Kyle on 2018-03-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingList: NSObject, NSCoding {
    
    var id: String
    var name: String
    var enabled: Bool
    var isDefault: Bool
    var rules: [BlockingRule]
    var createdDate: Date
    var updatedDate: Date
    
    init(name: String, enabled: Bool = true) {
        self.id = UUID().uuidString
        self.name = name
        self.enabled = enabled
        self.isDefault = false
        self.rules = []
        let now = Date()
        self.createdDate = now
        self.updatedDate = now
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: "uuid") as? String,
            let name = coder.decodeObject(forKey: "name") as? String,
            let rules = coder.decodeObject(forKey: "rules") as? [BlockingRule],
            let createdDate = coder.decodeObject(forKey: "createdDate") as? Date,
            let updatedDate = coder.decodeObject(forKey: "updatedDate") as? Date else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.rules = rules
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.isDefault = coder.decodeBool(forKey: "isDefault")
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(isDefault, forKey: "isDefault")
        coder.encode(rules, forKey: "rules")
        coder.encode(createdDate, forKey: "createdDate")
        coder.encode(updatedDate, forKey: "updatedDate")
    }
}
