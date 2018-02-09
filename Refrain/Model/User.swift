//
//  User.swift
//  Refrain
//
//  Created by Kyle on 2018-02-07.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

var UserKey = "userKey"

struct User: Codable {
    var uuid: String
    var apnsToken: Data?
    var startTimes: [Date] = []
    var stopTimes: [Date] = []
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
    init?(data: Data) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let uuid = json["uuid"] as? String
            else {
                    return nil
            }
            
            self.uuid = uuid
        }
        catch { return nil }
    }
    
    
    func urlEncoded() -> Data? {
        var string = "uuid=\(uuid)"
        if startTimes.count > 0 {
            string += "&startTimes=\(startTimes.map{ $0.toTimeInteger() })"
        }
        if stopTimes.count > 0 {
            string += "&stopTimes=\(startTimes.map{ $0.toTimeInteger() })"
        }
        if apnsToken != nil {
            string += "&apnsToken=\(String(data: apnsToken!, encoding: .utf8)!)"
        }
        return string.data(using: .utf8)
    }
}
