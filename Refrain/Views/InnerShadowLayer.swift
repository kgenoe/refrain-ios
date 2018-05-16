//
//  InnerShadowLayer.swift
//  Refrain
//
//  Created by Kyle on 2018-04-09.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class InnerShadowLayer: CALayer {
    
    private let defaultOpacity = Float(1)
    private let defaultOffset = CGSize.zero
    private let defaultRadius = CGFloat(2)
    private let defaultCornerRadius = CGFloat(0)
    
    
    init(frame: CGRect, opacity: Float? = nil, radius: CGFloat? = nil, offset: CGSize? = nil) {
        super.init()
        self.frame = frame
        self.styleInnerShadow(opacity: opacity, offset: offset, radius: radius)
    }
    
    override init() {
        super.init()
        self.styleInnerShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.styleInnerShadow()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.styleInnerShadow()
    }
    
    private func styleInnerShadow(opacity: Float? = nil, offset: CGSize? = nil, radius: CGFloat? = nil) {
        let path = UIBezierPath(roundedRect: frame.insetBy(dx: -10, dy: -10), cornerRadius: defaultCornerRadius)
        let innerPath = UIBezierPath(roundedRect: frame, cornerRadius: defaultCornerRadius).reversing()
        path.append(innerPath)
        shadowPath = path.cgPath
        masksToBounds = true
        shadowColor = UIColor.black.cgColor
        shadowOffset = offset ?? defaultOffset
        shadowOpacity = opacity ?? defaultOpacity
        shadowRadius = radius ?? defaultRadius
    }
}

