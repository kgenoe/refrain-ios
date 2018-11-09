//
//  IntentHandler.swift
//  CollectionsIntent
//
//  Created by Kyle on 2018-11-07.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"


class IntentHandler: INExtension, EnableBlockingCollectionIntentHandling, DisableBlockingCollectionIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func handle(intent: EnableBlockingCollectionIntent, completion: @escaping (EnableBlockingCollectionIntentResponse) -> Void) {
        
        guard let intentID = intent.blockingCollection?.identifier else {
            completion(EnableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
            return
        }

        //find the blocking collection with the intentID
        let collections = BlockingCollectionStore.shared.collections

        let matchedCollections = collections.filter{ $0.id == intentID }
        guard let collection = matchedCollections.first else {
            completion(EnableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
            return
        }

        collection.enabled = true

        BlockingCollectionStore.shared.saveCollection(collection)
        completion(EnableBlockingCollectionIntentResponse(code: .success, userActivity: nil))
    }
    
    func handle(intent: DisableBlockingCollectionIntent, completion: @escaping (DisableBlockingCollectionIntentResponse) -> Void) {
        
//        guard let intentID = intent.blockingCollection?.identifier else {
//            completion(DisableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
//            return
//        }
//
//        //find the blocking collection with the intentID
//        let collections = BlockingCollectionStore.shared.collections
//
//        let matchedCollections = collections.filter{ $0.id == intentID }
//        guard let collection = matchedCollections.first else {
//            completion(DisableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
//            return
//        }
//
//        collection.enabled = false
//
//        BlockingCollectionStore.shared.saveCollection(collection)
        completion(DisableBlockingCollectionIntentResponse(code: .success, userActivity: nil))
    }
    
}
