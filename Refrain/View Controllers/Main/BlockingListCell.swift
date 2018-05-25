//
//  BlockingListCell.swift
//  Refrain
//
//  Created by Kyle on 2018-04-21.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingListCell: SwitchTableViewCell {

    var blockingList: BlockingList!
    
    
    init(blockingList: BlockingList) {
        self.blockingList = blockingList
        
        super.init()
        enabledSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        setInitialState(for: blockingList)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setInitialState(for list: BlockingList) {
        titleLabel.text = list.name
        enabledSwitch.isOn = list.enabled
    }
    
    @objc func switchToggled() {
        blockingList.enabled = enabledSwitch.isOn
        BlockingListStore.shared.saveList(blockingList)
    }

}
