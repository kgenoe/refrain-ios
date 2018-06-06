//
//  CardView.swift
//  Refrain
//
//  Created by Kyle on 2018-03-14.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {

    private let cornerRadius = CGFloat(15.0)

    var title: String = "Blocking Collection" { didSet{ titleLabel.text = title } }

    var subtitle: String = "Set which sites to block with the option to group similar sites together to make them easier to toggle on and off." { didSet{
        subtitleLabel.text = subtitle
        subtitleLabelHeight.constant = subtitleLabel.intrinsicContentSize.height
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet private weak var subtitleLabelHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        // rounded corners
//        contentView.layer.cornerRadius = cornerRadius
//        self.backgroundColor = .clear
//        view.backgroundColor = .clear
        
        
        // outer shadow
//        layer.shadowRadius = 10
//        layer.shadowOffset = CGSize.zero
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.75
        
        self.setInnerShadow()
        
       subtitleLabelHeight.constant = subtitleLabel.intrinsicContentSize.height
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
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
    
    private func setBackgroundGradient() {
        contentView.layer.sublayers?.filter{ $0.name == "backgroundGradient" }
                             .forEach{ $0.removeFromSuperlayer() }
        
        let gradientColors = [UIColor(named: "White")!.cgColor, UIColor(named: "White")!.cgColor]
        let gradient = BackgroundGradientLayer(frame: bounds,
                                               colors: gradientColors,
                                               startPoint: .zero,
                                               endPoint: CGPoint(x: 0.66, y: 1.0))
        gradient.name = "backgroundGradient"
        contentView.layer.addSublayer(gradient)
    }

}
