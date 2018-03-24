//
//  BlockingScheduleListCell.swift
//  Refrain
//
//  Created by Kyle on 2018-03-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingScheduleListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    weak var schedule: BlockingSchedule!
    
    var blockingList: BlockingList!
    
    static func instantiate(from tableView: UITableView, schedule: BlockingSchedule, blockingList: BlockingList) -> BlockingScheduleListCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockingScheduleListCell") as! BlockingScheduleListCell
        
        cell.schedule = schedule
        cell.blockingList = blockingList
        
        cell.titleLabel.text = blockingList.name
        
        let isSelected = schedule.listIds.contains(blockingList.id)
        cell.accessoryType = isSelected ? .checkmark : .none
        
        let tap = UITapGestureRecognizer(target: cell, action: #selector(cell.tapped))
        cell.addGestureRecognizer(tap)
        
        return cell
    }

    
    @objc func tapped() {
        // If unselecting
        if accessoryType == .checkmark {
            schedule.listIds = schedule.listIds.filter{ $0 != blockingList.id }
            accessoryType = .none
        }
        // If selecting
        else if !schedule.listIds.contains(blockingList.id) {
            schedule.listIds.append(blockingList.id)
            accessoryType = .checkmark
        }
    }
}
