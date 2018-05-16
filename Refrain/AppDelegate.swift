//
//  AppDelegate.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        _ = AppearanceManager()
        
        UNUserNotificationCenter.current().requestAuthorization(options: []) { (granted, error) in
            guard error == nil else {
                print("UNUserNotificationCenter.requestAuthorization error: \(error!)")
                return
            }
            
            print("UNUserNotificationCenter.requestAuthorization granted = \(granted)")
        }
        
//        // DEBUGGING //
//        UpdateAccountRequest { (result) in
//            switch result {
//            case .Success(let resource):
//                print("Success")
//            case .Failure(let error):
//                print(error)
//            }
//            }.send()
//        // DEBUGGING //
        
        // Try to create account if one already doesnt exists (check by looking for userID)
        if UserDefaults.standard.string(forKey: DefaultsKey.userApiAccountToken) == nil {
            print("Create account request sending...")
            CreateAccountRequest { (result) in
                switch result {
                case .Success(let userID):
                    print("Created account with userID: \(userID)")
                    DispatchQueue.main.async {
                        print("Register for remote notifications after creating account...")
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                case .Failure(let error):
                    print("Error creating account:\n\(error)")
                }
            }.send()
        }
        

        // Check for a apnsToken before registering for remote notifications. If there is no apnsToken, it means a network request for one is in progress. registerForRemoteNotifications() after that request is completed.
        if UserDefaults.standard.string(forKey: DefaultsKey.apnsToken) == nil &&
            UserDefaults.standard.string(forKey: DefaultsKey.userApiAccountToken) != nil {
            DispatchQueue.main.async {
                print("Register for remote notifications...")
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let newToken = deviceToken.map{ data -> String in
            return String(format: "%02.2hhx", data)
        }.joined()
        
        print("New APN Device Token: \(newToken)")

        let currentToken = UserDefaults.standard.string(forKey: DefaultsKey.apnsToken)
        if currentToken != newToken {
            // if new token, save it and invalidate the old one
            UserDefaults.standard.set(newToken, forKey: DefaultsKey.apnsToken)
            UserDefaults.standard.set(false, forKey: DefaultsKey.savedApnsTokenToServer)
        }
        
        // Save token to server if previous one has been invalidated (or is 1st)
        let hasSavedKey = UserDefaults.standard.bool(forKey: DefaultsKey.savedApnsTokenToServer)
        if !hasSavedKey {
            UpdateAccountRequest { (result) in
                switch result {
                case .Success(_):
                    print("Successfully updated user profile with new APNs token")
                    UserDefaults.standard.set(true, forKey: DefaultsKey.savedApnsTokenToServer)
                case .Failure(let error):
                    print("Error updating user profile with new APNs token:\n\(error)")
                }
            }.send()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Update the server with the most recent schedules
        UpdateAccountRequest { (result) in
            switch result {
            case .Success(_): break
            case .Failure(let error):
                print(error)
            }
        }.send()
        
        
        // Update blockerList.json with current blocking rules        
        let lists = BlockingListStore.shared.lists
        let enabledLists = lists.filter{ $0.enabled }
        
        var enabledRules = [BlockingRule]()
        for list in enabledLists {
            enabledRules += list.rules.filter{ $0.enabled }
        }
        
        let filters = enabledRules.map{ $0.urlFilter }
        ContentBlockerManager.shared.update(filters)
        
    }
    
    
    private func updateContentBlocker() {
        var blockingItems = [[String: Any]]()
        
        let lists = BlockingListStore.shared.lists
        let enabledLists = lists.filter{ $0.enabled }
        
        for list in enabledLists {
            
            let enabledRules = list.rules.filter{ $0.enabled }
            
            for rule in enabledRules {
                
                let urlFilter = rule.urlFilter
                
                let trigger = ["url-filter": urlFilter]
                let action = ["type" : "block"]
                let item = ["trigger": trigger, "action": action]
                blockingItems.append(item)
            }
        }
        
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

