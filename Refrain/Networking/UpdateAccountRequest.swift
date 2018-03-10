//
//  UpdateAccountRequest.swift
//  Refrain
//
//  Created by Kyle on 2018-03-09.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

struct UpdateAccountRequest {
    
    enum FailCase: String, Error {
        case noLocalUUID
        case noLocalApnsToken
        
        var localizedDescription: String { return rawValue }
    }
    
    private let completionHandler: ((Result<Any?>) -> Void)
    
    init(_ completionHandler: @escaping (Result<Any?>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func send() {
        
        // Get request components
        guard let uuid = UserDefaults.standard.string(forKey: DefaultsKey.UUID) else {
            completionHandler(.Failure(FailCase.noLocalUUID))
            return
        }
        
        guard let apnsToken = UserDefaults.standard.string(forKey: DefaultsKey.apnsToken) else {
            completionHandler(.Failure(FailCase.noLocalApnsToken))
            return
        }
        
        let schedules = BlockingScheduleStore.shared.schedules
        let startTimes = schedules.map{ $0.startTime }
        let stopTimes = schedules.map{ $0.endTime }
        
        let startTimeIntegers = startTimes.map{ $0.toTimeInteger() }
        let stopTimeIntegers = stopTimes.map{ $0.toTimeInteger() }
        
        let startTimeString = startTimeIntegers.map{ "\($0)" }.joined(separator: ",")
        let stopTimeString = stopTimeIntegers.map{ "\($0)" }.joined(separator: ",")
        
        
        // Format URL encoded string
        var urlEncodedParameters = "uuid=\(uuid)&apnsToken=\(apnsToken)"
        urlEncodedParameters += "&startTimes=\(startTimeString)"
        urlEncodedParameters += "&stopTimes=\(stopTimeString)"
        
        
        // create request and append body
        var request = URLRequest(url: uesrsAPIURL)
        request.httpMethod = "PATCH"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = urlEncodedParameters.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                self.completionHandler(.Failure(error!))
                return
            }
            
            self.completionHandler(.Success(nil))
        }.resume()
    }

    
}

