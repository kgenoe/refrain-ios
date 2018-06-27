//
//  BlockingScheduleStructure.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-06-27.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

enum BlockingScheduleSection: Int, TableViewSection {
    
    case StartTime
    case EndTime
    case Collections
    
    /// Number of potentially available sections
    static var count: Int = {
        var max: Int = 0
        while let _ = BlockingCollectionSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static var all: [BlockingScheduleSection] = {
        var sections: [BlockingScheduleSection] = []
        var i = 0
        while let section = BlockingScheduleSection(rawValue: i) {
            i += 1
            sections.append(section)
        }
        return sections
    }()
}

enum BlockingScheduleRow: TableViewRow {
    case StartTimeHeader
    case StartTime
    case EndTimeHeader
    case EndTime
    case CollectionsHeader
    case Collection(Int)
}

struct BlockingScheduleStructure: TableViewStructure {
        
    var sections = BlockingScheduleSection.all
    
    private var collectionsRows: [BlockingScheduleRow] = []
    
    func rows(for section: BlockingScheduleSection) -> [BlockingScheduleRow] {
        switch section {
        case .StartTime: return [.StartTimeHeader, .StartTime]
        case .EndTime: return [.EndTimeHeader, .EndTime]
        case .Collections: return collectionsRows
        }
    }
    
    
    init(collectionCount: Int) {
        collectionsRows = [.CollectionsHeader]
        for i in 0..<collectionCount {
            collectionsRows.append(.Collection(i))
        }
    }
    
}
