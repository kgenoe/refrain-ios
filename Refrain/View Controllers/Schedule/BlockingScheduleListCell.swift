//
//  BlockingScheduleCollectionCell.swift
//  Refrain
//
//  Created by Kyle on 2018-03-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingScheduleCollectionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    weak var schedule: BlockingSchedule!
    
    var blockingCollection: BlockingCollection!
    
    static func instantiate(from tableView: UITableView, schedule: BlockingSchedule, blockingCollection: BlockingCollection) -> BlockingScheduleCollectionCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockingScheduleCollectionCell") as! BlockingScheduleCollectionCell
        
        cell.schedule = schedule
        cell.blockingCollection = blockingCollection
        
        cell.titleLabel.text = blockingCollection.name
        
        let isSelected = schedule.collectionIds.contains(blockingCollection.id)
        cell.accessoryType = isSelected ? .checkmark : .none
        
        let tap = UITapGestureRecognizer(target: cell, action: #selector(cell.tapped))
        cell.addGestureRecognizer(tap)
        
        return cell
    }

    
    @objc func tapped() {
        // If unselecting
        if accessoryType == .checkmark {
            schedule.collectionIds = schedule.collectionIds.filter{ $0 != blockingCollection.id }
            accessoryType = .none
        }
        // If selecting
        else if !schedule.collectionIds.contains(blockingCollection.id) {
            schedule.collectionIds.append(blockingCollection.id)
            accessoryType = .checkmark
        }
    }
}
