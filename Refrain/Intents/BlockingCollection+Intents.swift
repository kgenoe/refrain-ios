//
//  BlockingCollection+Intents.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-08-30.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation
import Intents

extension BlockingCollection {
    
    public var enableIntent: EnableBlockingCollectionIntent {
        let intent = EnableBlockingCollectionIntent()
        intent.blockingCollection = INObject(identifier: self.id, display: self.name)
        intent.suggestedInvocationPhrase = "Start blocking \(self.name)"
        return intent
    }
    
    public var disableIntent: DisableBlockingCollectionIntent {
        let intent = DisableBlockingCollectionIntent()
        intent.blockingCollection = INObject(identifier: self.id, display: self.name)
        intent.suggestedInvocationPhrase = "Stop blocking \(self.name)"
        return intent
    }
}
