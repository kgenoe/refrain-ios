//
//  DisableBlockingCollectionIntentHandler.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-09-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class DisableBlockingCollectionIntentHandler: NSObject, DisableBlockingCollectionIntentHandling {
    
    
    func handle(intent: DisableBlockingCollectionIntent, completion: @escaping (DisableBlockingCollectionIntentResponse) -> Void) {
        
        guard let intentID = intent.blockingCollection?.identifier else {
            completion(DisableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        //find the blocking collection with the intentID
        let collections = BlockingCollectionStore.shared.collections
        
        let matchedCollections = collections.filter{ $0.id == intentID }
        guard let collection = matchedCollections.first else {
            completion(DisableBlockingCollectionIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        collection.enabled = false
        
        BlockingCollectionStore.shared.saveCollection(collection)
        completion(DisableBlockingCollectionIntentResponse(code: .success, userActivity: nil))
    }
}
