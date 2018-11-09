//
//  SharedUserDefaults.swift
//  Refrain
//
//  Created by Kyle on 2018-11-08.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.ca.genoe.Refrain")!
    }
}
