//
//  MainTableViewStructure.swift
//  Refrain
//
//  Created by Kyle on 2018-05-18.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

enum MainTableViewSection: Int {
    
    case DefaultBlockingCollections
    case UserBlockingCollections
    case Schedules
    case Settings
    
    /// Number of potentially available Collectioning Sections
    static var count: Int = {
        var max: Int = 0
        while let _ = MainTableViewSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static var all: [MainTableViewSection] = {
        var sections: [MainTableViewSection] = []
        var i = 0
        while let section = MainTableViewSection(rawValue: i) {
            i += 1
            sections.append(section)
        }
        return sections
    }()
}


enum MainTableViewRow {
    
    case DefaultBlockingCollectionsHeader
    case DefaultBlockingCollections(Int)
    
    case UserBlockingCollectionsHeader
    case UserBlockingCollections(Int)
    case NewUserBlockingCollection
    
    case SchedulesHeader
    case Schedules
    
    case Settings
}


struct MainTableViewStructure {
    
    // Sections
    private var sections = MainTableViewSection.all
    
    // Rows
    private var defaultBlockingCollectionsRows: [MainTableViewRow] = []
    private var userBlockingCollectionsRows: [MainTableViewRow] = []
    private var schedulesRows: [MainTableViewRow] = []
    private var settingsRows: [MainTableViewRow] = []
    
    init(defaultCollectionsCount: Int, userCollectionsCount: Int){
        
        self.defaultBlockingCollectionsRows = [.DefaultBlockingCollectionsHeader]
        for i in 0..<defaultCollectionsCount {
            defaultBlockingCollectionsRows.append(.DefaultBlockingCollections(i))
        }
        
        self.userBlockingCollectionsRows = [.UserBlockingCollectionsHeader]
        for i in 0..<userCollectionsCount {
            userBlockingCollectionsRows.append(.UserBlockingCollections(i))
        }
        userBlockingCollectionsRows.append(.NewUserBlockingCollection)
        
        if UserDefaults.standard.bool(forKey: DefaultsKey.extrasPurchased) {
            self.schedulesRows = [.SchedulesHeader, .Schedules]
        }
        
        self.settingsRows = [.Settings]
    }
    
    
    
    //MARK: - Section Management
    func sectionCount() -> Int {
        return sections.count
    }
    
    func sectionTypeFor(_ section: Int)  -> MainTableViewSection {
        return sections[section]
    }
    
    func sectionIndexFor(_ section: MainTableViewSection) -> Int? {
        return sections.index(of: section)
    }
    
    
    
    //MARK: - Row Management
    func rows(for section: MainTableViewSection) -> [MainTableViewRow] {
        switch section {
        case .DefaultBlockingCollections: return defaultBlockingCollectionsRows
        case .UserBlockingCollections: return userBlockingCollectionsRows
        case .Schedules: return schedulesRows
        case .Settings: return settingsRows
        }
    }
    
    func rowCountFor(_ section: Int) -> Int{
        let sectionType = sectionTypeFor(section)
        return rows(for: sectionType).count
    }
    
    func rowType(for indexPath: IndexPath) -> MainTableViewRow {
        let section = sectionTypeFor(indexPath.section)
        let rows = self.rows(for: section)
        return rows[indexPath.row]
    }
}

