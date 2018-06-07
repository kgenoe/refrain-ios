//
//  UIAlertController+backgroundColor.swift
//  Refrain
//
//  Created by Kyle on 2018-06-07.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func setBackgroundColor(_ color: UIColor) {
        
        let container = self.view.subviews.first
        let content = container?.subviews.first
        
        for subview in content?.subviews ?? [] {
            subview.backgroundColor = color
        }
    }
}
