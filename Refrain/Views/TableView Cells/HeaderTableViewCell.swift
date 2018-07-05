//
//  HeaderTableViewCell.swift
//  Refrain
//
//  Created by Kyle on 2018-05-17.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    init(title: String) {
        super.init(style: .subtitle, reuseIdentifier: nil)
        self.textLabel?.text = title
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
        backgroundColor = .clear
        selectionStyle = .none

        textLabel?.textColor = UIColor(named: "White")!
        
        let avenir = UIFont(name: "Avenir-Book", size: 16.0)!
        textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: avenir)
        textLabel?.adjustsFontForContentSizeCategory = true
    }
}
