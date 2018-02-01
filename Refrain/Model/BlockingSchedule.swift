//
//  BlockingSchedule.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingSchedule: NSObject, NSCoding {
    
    var startTime: Date
    var endTime: Date
    var enabled: Bool
    var createdDate: Date
    var updatedDate: Date
    
    init(startTime: Date, endTime: Date, enabled: Bool = true) {
        self.startTime = startTime
        self.endTime = endTime
        self.enabled = enabled
        let now = Date()
        self.createdDate = now
        self.updatedDate = now
    }
    
    
    required init?(coder: NSCoder) {
        guard let startTime = coder.decodeObject(forKey: "startTime") as? Date,
            let endTime = coder.decodeObject(forKey: "endTime") as? Date,
            let createdDate = coder.decodeObject(forKey: "createdDate") as? Date,
            let updatedDate = coder.decodeObject(forKey: "updatedDate") as? Date else {
                return nil
        }
        
        self.startTime = startTime
        self.endTime = endTime
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(startTime, forKey: "startTime")
        coder.encode(endTime, forKey: "endTime")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(createdDate, forKey: "createdDate")
        coder.encode(updatedDate, forKey: "updatedDate")
    }
}
