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
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SwitchTableViewCell", bundle: bundle)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return cell
    }
    
    
    private func setupView() {
        let cell = viewFromNibForClass()
        cell.frame = bounds
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(cell)
    }
}