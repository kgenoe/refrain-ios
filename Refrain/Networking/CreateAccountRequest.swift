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
        case noUUIDinResponseData
        
        var localizedDescription: String { return rawValue }
    }
    
    private let completionHandler: ((Result<Any>) -> Void)
    
    init(_ completionHandler: @escaping (Result<Any>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func send() {
        
        // Don't send create account Request if already hold a UUID
        guard UserDefaults.standard.string(forKey: DefaultsKey.UUID) == nil else {
            completionHandler(.Failure(FailCase.accountAlreadyExists))
            return
        }
        
        var request = URLRequest(url: uesrsAPIURL)
        request.httpMethod = "POST"
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                self.completionHandler(.Failure(error!))
                return
            }
            
            guard let data = data else {
                self.completionHandler(.Failure(FailCase.noDataInResponse))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                
                guard let uuid = json["uuid"] as? String else {
                    self.completionHandler(.Failure(FailCase.noUUIDinResponseData))
                    return
                }
                
                //save UUID
                print("Found UUID: \(uuid)")
                UserDefaults.standard.set(uuid, forKey: DefaultsKey.UUID)
                
                self.completionHandler(.Success(uuid))
            }
            catch {
                print("Response:\n\(String(data: data, encoding: .utf8)!)")
                self.completionHandler(.Failure(error))
                return
            }
        }.resume()
    }
}


