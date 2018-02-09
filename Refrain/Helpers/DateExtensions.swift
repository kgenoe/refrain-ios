//
//  DateExtensions.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

extension Date {
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    
    static func defaultStart() -> Date {
        let offset = TimeInterval(Calendar.current.timeZone.secondsFromGMT())
        return Date(timeIntervalSince1970: (60*60*9)-(offset))
    }
    
    static func defaultEnd() -> Date {
        let offset = TimeInterval(Calendar.current.timeZone.secondsFromGMT())
        print(offset/(60*60))
        return Date(timeIntervalSince1970: (60*60*17)-(offset))
    }
    
    
    
    //MARK: - Time Integer
    // Time Integer is a number between 0 and 1439, representing the current minute in the day. (There are 1440 minutes in a day). This is how a timestamp is represented in the database.
    init?(fromTimeInteger integer: Int) {
        let minutes = integer % 60
        let hour = (integer-minutes)/60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        if let date = formatter.date(from: "\(hour):\(minutes)") {
            self = date
        } else {
            return nil
        }
    }
    
    func toTimeInteger() -> Int {
        let hour = Calendar.current.component(.hour, from: self)
        let mins = Calendar.current.component(.minute, from: self)
        return (hour*60)+mins
    }
}
