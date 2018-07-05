//
//  ItemTableViewCell.swift
//  Refrain
//
//  Created by Kyle on 2018-06-05.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    private var contentAccessoryType: AccessoryType = .disclosureIndicator
    
    init(text: String, accessoryType: AccessoryType = .disclosureIndicator) {
        self.contentAccessoryType = accessoryType
        super.init(style: .default, reuseIdentifier: nil)
        textLabel?.text = text
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    private func setupView() {
        textLabel?.textColor = UIColor(named: "DarkGrey")!
        
        let avenir = UIFont(name: "Avenir-Book", size: 16.0)!
        textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: avenir)
        textLabel?.adjustsFontForContentSizeCategory = true
    }
}
