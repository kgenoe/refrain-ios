//
//  ItemTableViewCell.swift
//  Refrain
//
//  Created by Kyle on 2018-06-05.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var contentAccessoryType: AccessoryType = .disclosureIndicator
    
    init(text: String, accessoryType: AccessoryType = .disclosureIndicator) {
        self.contentAccessoryType = accessoryType
        super.init(style: .default, reuseIdentifier: nil)
        self.setupView()
        titleLabel.text = text
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
        let nib = UINib(nibName: "ItemTableViewCell", bundle: bundle)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! UITableViewCell
        return cell
    }
    
    
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        if let cell = view as? UITableViewCell {
            cell.accessoryType = contentAccessoryType
        }
    }
}
