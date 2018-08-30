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
    
    public var intent: EnableBlockingCollectionIntent {
        
        let enableIntent = EnableBlockingCollectionIntent()
        
        enableIntent.blockingCollection = INObject(identifier: self.id, display: self.name)
        enableIntent.suggestedInvocationPhrase = "Start blocking \(self.name)"
        
        return enableIntent
    }

}
