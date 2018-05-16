//
//  SwitchTableViewCell.swift
//  Refrain
//
//  Created by Kyle on 2018-04-13.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        self.setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func cellFromNibForClass() -> UITableViewCell {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SwitchTableViewCell", bundle: bundle)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! UITableViewCell
        return cell
    }
    
    
    private func setupView() {
        
        let cell = cellFromNibForClass()
        cell.frame = bounds
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(cell)
        
        titleLabel.font = UIFont(name: "Avenir Book", size: 16.0)
        titleLabel.textColor = UIColor(named: "DarkGrey")!
        enabledSwitch.onTintColor = UIColor(named: "Orange")!
        self.setInnerShadow()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setInnerShadow()
    }

    
    private func setInnerShadow() {
        layer.sublayers?.filter{ $0.name == "innerShadow" }
            .forEach{ $0.removeFromSuperlayer() }
        let innerShadow = InnerShadowLayer(frame: bounds.insetBy(dx: -20, dy: 0).offsetBy(dx: 10, dy: 0))
        innerShadow.name = "innerShadow"
        layer.addSublayer(innerShadow)
    }
}
