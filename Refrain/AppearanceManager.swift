//
//  AppearanceManager.swift
//  Refrain
//
//  Created by Kyle on 2018-04-08.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

struct AppearanceManager {
    
    
    init() {
        
        // UINavigationBar
        let navigationBarAppearace = UINavigationBar.appearance()

        let navBarAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "White")!,
            .font: UIFont(name: "Georgia-Bold", size: 20)!,
            .backgroundColor: UIColor.clear
        ]
        navigationBarAppearace.titleTextAttributes = navBarAttributes
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.isTranslucent = true
        
        
        // UIBarButtonItem
        let barButtonAppearance = UIBarButtonItem.appearance()
        let barButtonAttributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "White")!,
            .font: UIFont(name: "Avenir-Roman", size: 18.0)!
        ]
        barButtonAppearance.setTitleTextAttributes(barButtonAttributes, for: [])
    }
}
