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
}
