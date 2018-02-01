//
//  BlockingRule.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingRule: NSObject, NSCoding {
    
    var name: String
    var urlFilter: String
    var enabled: Bool
    var createdDate: Date
    var updatedDate: Date
    
    init(name: String, urlFilter: String, enabled: Bool = true) {
        self.name = name
        self.urlFilter = urlFilter
        self.enabled = enabled
        let now = Date()
        self.createdDate = now
        self.updatedDate = now
    }
    
    
    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String,
            let urlFilter = coder.decodeObject(forKey: "urlFilter") as? String,
            let createdDate = coder.decodeObject(forKey: "createdDate") as? Date,
            let updatedDate = coder.decodeObject(forKey: "updatedDate") as? Date else {
                return nil
        }
        
        self.name = name
        self.urlFilter = urlFilter
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(urlFilter, forKey: "urlFilter")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(createdDate, forKey: "createdDate")
        coder.encode(updatedDate, forKey: "updatedDate")
    }
}
