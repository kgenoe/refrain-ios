//
//  BlockingSchedule.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingSchedule: NSObject, NSCoding {
    
    var id: String
    var startTime: Date
    var endTime: Date
    var enabled: Bool
    var collectionIds: [String]
    var createdDate: Date
    var updatedDate: Date
    
    init(startTime: Date, endTime: Date, enabled: Bool = true) {
        self.id = UUID().uuidString
        self.startTime = startTime
        self.endTime = endTime
        self.enabled = enabled
        self.collectionIds = []
        let now = Date()
        self.createdDate = now
        self.updatedDate = now
    }
    
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: "uuid") as? String,
            let startTime = coder.decodeObject(forKey: "startTime") as? Date,
            let endTime = coder.decodeObject(forKey: "endTime") as? Date,
            let collectionIds = coder.decodeObject(forKey: "collectionIds") as? [String],
            let createdDate = coder.decodeObject(forKey: "createdDate") as? Date,
            let updatedDate = coder.decodeObject(forKey: "updatedDate") as? Date else {
                return nil
        }
        
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.collectionIds = collectionIds
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "uuid")
        coder.encode(startTime, forKey: "startTime")
        coder.encode(endTime, forKey: "endTime")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(collectionIds, forKey: "collectionIds")
        coder.encode(createdDate, forKey: "createdDate")
        coder.encode(updatedDate, forKey: "updatedDate")
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "id"        : id,
            "startTime" : startTime.toTimeInteger(),
            "stopTime"  : endTime.toTimeInteger(),
        ]
    }
}
