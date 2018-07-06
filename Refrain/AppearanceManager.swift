//
//  AppearanceManager.swift
//  Refrain
//
//  Created by Kyle on 2018-04-08.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import MessageUI

struct AppearanceManager {
    
    enum Theme {
        case Dark
        case Light
    }
    
    var theme: Theme = .Dark { didSet { configure() } }
    
    func configure() {
        switch theme {
        case .Dark:     configureDarkTheme()
        case .Light:    configureLightTheme()
        }
    }
    
    private func configureDarkTheme() {
        
        // UINavigationBar
        let navigationBarAppearace = UINavigationBar.appearance()
        
        let navBarTitleAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "White")!,
            .font: UIFont(name: "Georgia-Bold", size: 20)!,
            .backgroundColor: UIColor.clear
        ]
        
        let navBarLargeTitleAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "White")!,
            .font: UIFont(name: "Georgia-Bold", size: 30)!,
            .backgroundColor: UIColor.clear
        ]
        
        
        navigationBarAppearace.titleTextAttributes = navBarTitleAttributes
        navigationBarAppearace.largeTitleTextAttributes = navBarLargeTitleAttributes
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.prefersLargeTitles = true
        
        
        // UIBarButtonItem
        let barButtonAppearance = UIBarButtonItem.appearance()
        let barButtonAttributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "White")!,
            .font: UIFont(name: "Avenir-Roman", size: 18.0)!
        ]
        barButtonAppearance.setTitleTextAttributes(barButtonAttributes, for: [])
    }
    
    private func configureLightTheme() {
        // UINavigationBar
        let navigationBarAppearace = UINavigationBar.appearance()
        
        let navBarTitleAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "DarkGrey")!,
            .font: UIFont(name: "Georgia-Bold", size: 20)!,
            .backgroundColor: UIColor.clear
        ]
        
        let navBarLargeTitleAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "DarkGrey")!,
            .font: UIFont(name: "Georgia-Bold", size: 30)!,
            .backgroundColor: UIColor.clear
        ]
        
        
        navigationBarAppearace.titleTextAttributes = navBarTitleAttributes
        navigationBarAppearace.largeTitleTextAttributes = navBarLargeTitleAttributes
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.prefersLargeTitles = true
        
        
        // UIBarButtonItem
        let barButtonAppearance = UIBarButtonItem.appearance()
        let barButtonAttributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "DarkGrey")!,
            .font: UIFont(name: "Avenir-Roman", size: 18.0)!
        ]
        barButtonAppearance.setTitleTextAttributes(barButtonAttributes, for: [])
    }
}
