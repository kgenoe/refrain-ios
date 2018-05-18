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
        
        super.init()
        enabledSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        setInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setInitialState()
    {
        titleLabel.text = "\(blockingSchedule.startTime.timeString()) - \(blockingSchedule.endTime.timeString())"
        enabledSwitch.isOn = blockingSchedule.enabled
    }
    
    @objc func switchToggled() {
        blockingSchedule.enabled = enabledSwitch.isOn
        BlockingScheduleStore.shared.save(blockingSchedule)
    }

}
