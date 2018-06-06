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
        
        super.init()
        enabledSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        setInitialState(for: blockingCollection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setInitialState(for collection: BlockingCollection) {
        titleLabel.text = collection.name
        enabledSwitch.isOn = collection.enabled
    }
    
    @objc func switchToggled() {
        blockingCollection.enabled = enabledSwitch.isOn
        BlockingCollectionStore.shared.saveCollection(blockingCollection)
    }

}
