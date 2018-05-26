//
//  NotificationsSplashViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-05-25.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationsSplashViewController: UIViewController {

    static func instantiate() -> NotificationsSplashViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsSplashViewController") as! NotificationsSplashViewController
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonPressed() {
        UNUserNotificationCenter.current().requestAuthorization(options: []) { (granted, error) in
  
            guard granted else { return }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setBackgroundGradient()
    }
    
    private func setBackgroundGradient() {
        view.layer.sublayers?.filter{ ($0 as? BackgroundGradientLayer) != nil }
            .forEach{ $0.removeFromSuperlayer() }
        
        let gradient = BackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradient)
    }
}
