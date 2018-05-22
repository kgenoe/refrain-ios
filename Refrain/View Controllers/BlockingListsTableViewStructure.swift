//
//  BlockingListsTableViewStructure.swift
//  Refrain
//
//  Created by Kyle on 2018-05-18.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

enum BlockingListsSection: Int {
    
    case DefaultBlockingLists
    case UserBlockingLists
    case Settings
    
    /// Number of potentially available Listing Sections
    static var count: Int = {
        var max: Int = 0
        while let _ = BlockingListsSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static var all: [BlockingListsSection] = {
        var sections: [BlockingListsSection] = []
        var i = 0
        while let section = BlockingListsSection(rawValue: i) {
            i += 1
            sections.append(section)
        }
        return sections
    }()
}


enum BlockingListsRow {
    
    case DefaultBlockingListsHeader
    case DefaultBlockingLists(Int)
    
    case UserBlockingListsHeader
    case UserBlockingLists(Int)
    case NewUserBlockingList
    
    case Settings
}


struct BlockingListsTableViewStructure {
    
    // Sections
    private var sections = BlockingListsSection.all
    
    // Rows
    private var defaultBlockingListsRows: [BlockingListsRow]
    private var userBlockingListsRows: [BlockingListsRow]
    private var settingsRows: [BlockingListsRow]
    
    init(defaultListsCount: Int, userListsCount: Int){
        
        self.defaultBlockingListsRows = [.DefaultBlockingListsHeader]
        for i in 0..<defaultListsCount {
            defaultBlockingListsRows.append(.DefaultBlockingLists(i))
        }
        
        self.userBlockingListsRows = [.UserBlockingListsHeader]
        for i in 0..<userListsCount {
            userBlockingListsRows.append(.UserBlockingLists(i))
        }
        userBlockingListsRows.append(.NewUserBlockingList)
        
        self.settingsRows = [.Settings]
    }
    
    
    
    //MARK: - Section Management
    func sectionCount() -> Int {
        return sections.count
    }
    
    func sectionTypeFor(_ section: Int)  -> BlockingListsSection {
        return sections[section]
    }
    
    func sectionIndexFor(_ section: BlockingListsSection) -> Int? {
        return sections.index(of: section)
    }
    
    
    
    //MARK: - Row Management
    func rows(for section: BlockingListsSection) -> [BlockingListsRow] {
        switch section {
        case .DefaultBlockingLists: return defaultBlockingListsRows
        case .UserBlockingLists: return userBlockingListsRows
        case .Settings: return settingsRows
        }
    }
    
    func rowCountFor(_ section: Int) -> Int{
        let sectionType = sectionTypeFor(section)
        return rows(for: sectionType).count
    }
    
    func rowType(for indexPath: IndexPath) -> BlockingListsRow {
        let section = sectionTypeFor(indexPath.section)
        let rows = self.rows(for: section)
        return rows[indexPath.row]
    }
}

