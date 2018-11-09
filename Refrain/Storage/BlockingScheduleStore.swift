//
//  BlockingScheduleStore.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

class BlockingScheduleStore: NSObject {
    
    static let shared = BlockingScheduleStore()
    
    // UserDefaults keys
    private let scheduleStore = "scheduleStore"
    private let wasScheduleStoreCreated = "wasScheduleStoreCreated"
    
    private override init() {
        let scheduleStoreCreated = UserDefaults.shared.bool(forKey: wasScheduleStoreCreated)
        if !scheduleStoreCreated {
            let data = try! NSKeyedArchiver.archivedData(withRootObject: [BlockingSchedule](), requiringSecureCoding: false)
            UserDefaults.shared.set(data, forKey: scheduleStore)
            UserDefaults.shared.set(true, forKey: wasScheduleStoreCreated)
        }
    }
    
    
    // Saves a new schedule. If the schedule already exists in the store, it is updated.
    func save(_ newSchedule: BlockingSchedule) {
        
        var existingSchedules = self.schedules
        
        // if new schedule
        if !existingSchedules.contains(where: { $0.createdDate == newSchedule.createdDate }) {
            existingSchedules.append(newSchedule)
        }
        // else, update existing rule
        else {
            for i in 0..<existingSchedules.count {
                let existingSchedule = existingSchedules[i]
                if existingSchedule.createdDate == newSchedule.createdDate {
                    existingSchedules[i] = newSchedule
                    break
                }
            }
        }
        
        // Save changed schedules to defaults
        let data = try! NSKeyedArchiver.archivedData(withRootObject: existingSchedules, requiringSecureCoding: false)
        UserDefaults.shared.set(data, forKey: scheduleStore)
    }
    
    
    func delete(_ schedule: BlockingSchedule) {
        
        var existingSchedules = self.schedules
        
        for i in 0..<existingSchedules.count {
            let existingSchedule = existingSchedules[i]
            if existingSchedule.createdDate == schedule.createdDate {
                existingSchedules.remove(at: i)
                break
            }
        }
        
        // Save changed rules to defaults
        let data = try! NSKeyedArchiver.archivedData(withRootObject: existingSchedules, requiringSecureCoding: false)
        UserDefaults.shared.set(data, forKey: scheduleStore)
    }
    
    
    
    // An array of all currently stored blocking schedules. Repeated calls of schedules should be avoided if possible for performance.
    var schedules: [BlockingSchedule] {
        let data = UserDefaults.shared.data(forKey: scheduleStore)!
        do {
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return object as? [BlockingSchedule] ?? []
        } catch {
            print("Error unarchiving Blocking Schedules:\n\(error)")
            return []
        }
    }
}
