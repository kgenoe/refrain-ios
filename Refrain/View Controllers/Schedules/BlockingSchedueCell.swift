//
//  BlockingSchedueCell.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingSchedueCell: SwitchTableViewCell {

    var blockingSchedule: BlockingSchedule!
    
    init(blockingSchedule: BlockingSchedule) {
        self.blockingSchedule = blockingSchedule
        
        let title = "\(blockingSchedule.startTime.timeString()) - \(blockingSchedule.endTime.timeString())"
        super.init(text: title, accessoryType: .none)
        
        accessorySwitch.isOn = blockingSchedule.enabled
        accessorySwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchToggled() {
        blockingSchedule.enabled = accessorySwitch.isOn
        BlockingScheduleStore.shared.save(blockingSchedule)
    }

}
