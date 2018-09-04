//
//  EnableBlockingCollectionIntentHandler.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-08-30.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class EnableBlockingCollectionIntentHandler: NSObject, EnableBlockingCollectionIntentHandling {
    
    
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
}
