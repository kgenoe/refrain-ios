//
//  CreateAccountRequest.swift
//  Refrain
//
//  Created by Kyle on 2018-03-09.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

struct CreateAccountRequest {
    
    enum FailCase: String, Error {
        case accountAlreadyExists
        case noDataInResponse
        case noUserIDinResponseData
        
        var localizedDescription: String { return rawValue }
    }
    
    private let completionHandler: ((Result<Any>) -> Void)?
    
    init(_ completionHandler: ((Result<Any>) -> Void)? = nil) {
        self.completionHandler = completionHandler
    }
    
    func send() {
        
        completionHandler?(.Success("test"))
        
        // Don't send create account Request if already hold a userApiAccountToken
        guard UserDefaults.shared.string(forKey: DefaultsKey.userApiAccountToken) == nil else {
            completionHandler?(.Failure(FailCase.accountAlreadyExists))
            return
        }
        
        var request = URLRequest(url: uesrsAPIURL)
        request.httpMethod = "POST"
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                self.completionHandler?(.Failure(error!))
                return
            }
            
            guard let data = data else {
                self.completionHandler?(.Failure(FailCase.noDataInResponse))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                
                guard let userID = json["userID"] as? String else {
                    self.completionHandler?(.Failure(FailCase.noUserIDinResponseData))
                    return
                }
                
                //save UserID
                print("Found userApiAccountToken: \(userID)")
                UserDefaults.shared.set(userID, forKey: DefaultsKey.userApiAccountToken)
                
                self.completionHandler?(.Success(userID))
            }
            catch {
                print("Response:\n\(String(data: data, encoding: .utf8)!)")
                self.completionHandler?(.Failure(error))
                return
            }
        }.resume()
    }
}


