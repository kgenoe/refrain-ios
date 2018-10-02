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
    
        AppearanceManager().configure()

        DefaultBlockingCollections().createDefaultCollections()
        
        UserDefaults.standard.set(true, forKey: DefaultsKey.extrasPurchased)
    
        return true
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        print("Restoring user state...")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // A CreateAccountRequest is sent immediately after premium is unlocked but if that request fails, this one will continue to try to send the request. This request will fail immediately if the account has already been created.
        if UserDefaults.standard.bool(forKey: DefaultsKey.extrasPurchased) {
            CreateAccountRequest().send()
        }
        
        // registerForRemoteNotifications is called if the user allows notifications on the 1st prompt. If they decline & enable in settings, this check will pick that up and make the registerForRemoteNotifications call.
        // Check for a apnsToken before registering for remote notifications. If there is no apnsToken, it means a network request for one is in progress. registerForRemoteNotifications() after that request is completed.
        if UserDefaults.standard.string(forKey: DefaultsKey.apnsToken) == nil &&
            UserDefaults.standard.string(forKey: DefaultsKey.userApiAccountToken) != nil {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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
                print("Error updating account: \(error)")
            }
        }.send()
        
        
        // Update blockerCollection.json with current blocking rules        
        let collections = BlockingCollectionStore.shared.collections
        let enabledCollections = collections.filter{ $0.enabled }
        
        var enabledRules = [BlockingRule]()
        for collection in enabledCollections {
            enabledRules += collection.rules.filter{ $0.enabled }
        }
        
        let filters = enabledRules.map{ $0.urlFilter }
        ContentBlockerManager.shared.update(filters)
    }
}

