//
//  IntentsManager.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-09-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation
import Intents

class IntentsManager: NSObject {
    
    static let shared = IntentsManager()
    
    private override init() { }
    
    func donate(enabledCollection: BlockingCollection) {
        let interaction = INInteraction(intent: enabledCollection.enableIntent, response: nil)
        interaction.donate { (error) in
            guard error == nil else {
                print("Error donating intent: \(error!)")
                return
            }
        }
    }
    
    func donate(disabledCollection: BlockingCollection) {
        let interaction = INInteraction(intent: disabledCollection.disableIntent, response: nil)
        interaction.donate { (error) in
            guard error == nil else {
                print("Error donating intent: \(error!)")
                return
            }
        }
    }
    
    func delete(collection: BlockingCollection) {
        INInteraction.delete(with: [collection.id]) { (error) in
            guard error == nil else {
                print("Error deleting intents: \(error!)")
                return
            }
        }
    }
}
