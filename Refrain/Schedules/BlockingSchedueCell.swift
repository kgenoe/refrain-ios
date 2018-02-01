//
//  BlockingSchedueCell.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingSchedueCell: UITableViewCell {

    var blockingSchedule: BlockingSchedule!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    
    static func instantiate(from tableView: UITableView, blockingSchedule: BlockingSchedule) -> BlockingSchedueCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockingSchedueCell") as! BlockingSchedueCell
        cell.blockingSchedule = blockingSchedule
        cell.setInitialState(for: blockingSchedule)
        return cell
    }
    
    
    private func setInitialState(for schedule: BlockingSchedule) {
        titleLabel.text = "\(schedule.startTime.timeString()) - \(schedule.endTime.timeString())"
        enabledSwitch.isOn = schedule.enabled
    }
    
    @IBAction func switchToggled() {
        blockingSchedule.enabled = enabledSwitch.isOn
        BlockingScheduleStore.shared.save(blockingSchedule)
    }

}
