//
//  BackgroundGradientLayer.swift
//  Refrain
//
//  Created by Kyle on 2018-04-07.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BackgroundGradientLayer: CAGradientLayer {
    
    
    
    init(frame: CGRect, colors: [CGColor]? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        super.init()
        styleGradient()
        self.frame = frame
        if let colors = colors { self.colors = colors }
        if let startPoint = startPoint { self.startPoint = startPoint }
        if let endPoint = endPoint { self.endPoint = endPoint }
    }
    
    override init() {
       super.init()
        styleGradient()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        styleGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleGradient()
    }
    
    private func styleGradient() {
        name = "backgroundGradient"
        colors = [UIColor(named: "Gradient1")!.cgColor, UIColor(named: "Gradient2")!.cgColor]
        startPoint = CGPoint(x: 0.5, y: 0)
        endPoint = CGPoint(x: 0.5, y: 1.0)
        zPosition = -1
    }
}
