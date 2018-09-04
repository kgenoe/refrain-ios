//
//  BlockingCollectionCell.swift
//  Refrain
//
//  Created by Kyle on 2018-04-21.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingCollectionCell: SwitchTableViewCell {

    var blockingCollection: BlockingCollection!
    
    
    init(blockingCollection: BlockingCollection) {
        self.blockingCollection = blockingCollection
        
        super.init(text: blockingCollection.name, accessoryType: .none)
        
        accessorySwitch.isOn = blockingCollection.enabled
        accessorySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func switchToggled() {
        blockingCollection.enabled = accessorySwitch.isOn
        BlockingCollectionStore.shared.saveCollection(blockingCollection)
        
        // donate intents
        if blockingCollection.enabled {
            IntentsManager.shared.donate(enabledCollection: blockingCollection)
        } else {
            IntentsManager.shared.donate(disabledCollection: blockingCollection)
        }
    }

}
