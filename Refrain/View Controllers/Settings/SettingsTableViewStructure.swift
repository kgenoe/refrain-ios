//
//  SettingsTableViewStructure.swift
//  Refrain
//
//  Created by Kyle on 2018-06-27.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

enum SettingsTableViewSection: Int, TableViewSection {
    
    case PremiumFeatures
    case HowTo
    case Feedback
    case About
    
    
    /// Number of potentially available Collectioning Sections
    static var count: Int = {
        var max: Int = 0
        while let _ = SettingsTableViewSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static var all: [SettingsTableViewSection] = {
        var sections: [SettingsTableViewSection] = []
        var i = 0
        while let section = SettingsTableViewSection(rawValue: i) {
            i += 1
            sections.append(section)
        }
        return sections
    }()
}


enum SettingsTableViewRow: TableViewRow {
    
    case PremiumFeatures
    
    case HowToEnable
    case HowToUse
    
    case ReviewOnAppStore
    case RequestFeature
    case ReportProblem
    
    case About
}


struct SettingsTableViewStructure: TableViewStructure {
    
    // Sections
    var sections = SettingsTableViewSection.all
    
    init(){   }
    
    
    
    //MARK: - Section Management
    func sectionIndex(for section: SettingsTableViewSection) -> Int? {
        return sections.index(of: section)
    }
    
    
    
    //MARK: - Row Management
    func rows(for section: SettingsTableViewSection) -> [SettingsTableViewRow] {
        switch section {
        case .PremiumFeatures:  return [.PremiumFeatures]
        case .HowTo:            return [.HowToEnable, .HowToUse]
        case .Feedback:         return [.ReviewOnAppStore, .RequestFeature, .ReportProblem]
        case .About:            return [.About]
        }
    }
}
