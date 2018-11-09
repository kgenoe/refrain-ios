//
//  UpdateAccountRequest.swift
//  Refrain
//
//  Created by Kyle on 2018-03-09.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

struct UpdateAccountRequest {
    
    enum FailCase: String, Error {
        case noLocalUserID
        case noLocalApnsToken
        case invalidJsonPayload
        
        var localizedDescription: String { return rawValue }
    }
    
    private let completionHandler: ((Result<Any?>) -> Void)?
    
    init(_ completionHandler: ((Result<Any?>) -> Void)? = nil) {
        self.completionHandler = completionHandler
    }
    
    func send() {
        
        // Get request components
        guard let userApiAccountToken = UserDefaults.shared.string(forKey: DefaultsKey.userApiAccountToken) else {
            completionHandler?(.Failure(FailCase.noLocalUserID))
            return
        }

        let apnsToken = UserDefaults.shared.string(forKey: DefaultsKey.apnsToken) ?? ""
        
        let schedules = BlockingScheduleStore.shared.schedules
        let scheduleDicts = schedules.map{ $0.toDictionary() }
            
        let payload: [String: Any] = [
            "userID": userApiAccountToken,
            "apnsToken": apnsToken,
            "schedules": scheduleDicts
        ]
        
    
        
        guard JSONSerialization.isValidJSONObject(payload) else {
            completionHandler?(.Failure(FailCase.invalidJsonPayload))
            return
        }
        
        // create request and append body
        var request = URLRequest(url: uesrsAPIURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                self.completionHandler?(.Failure(error!))
                return
            }
            
            self.completionHandler?(.Success(nil))
        }.resume()
    }

    
}

