//
//  SwitchTableViewCell.swift
//  Refrain
//
//  Created by Kyle on 2018-04-13.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class SwitchTableViewCell: ItemTableViewCell {
    
    private(set) var accessorySwitch = UISwitch()
    
    override init(text: String, accessoryType: AccessoryType = .disclosureIndicator) {
        super.init(text: text, accessoryType: accessoryType)
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
        accessoryView = accessorySwitch
        accessorySwitch.onTintColor = UIColor(named: "Orange")!
    }
}
