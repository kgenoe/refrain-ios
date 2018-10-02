//
//  IntentHandler.swift
//  Shortcuts
//
//  Created by Kyle Genoe on 2018-08-30.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Intents


class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {

        return EnableBlockingCollectionIntentHandler()

        if type(of: intent) == EnableBlockingCollectionIntent.self {
            print("Handle enable intent")
            return EnableBlockingCollectionIntentHandler()
        } else if type(of: intent) == DisableBlockingCollectionIntent.self {
            print("Handle disable intent")
            return DisableBlockingCollectionIntentHandler()
        } else {
            fatalError("Unhandled intent type: \(intent)")
        }
    }
}
