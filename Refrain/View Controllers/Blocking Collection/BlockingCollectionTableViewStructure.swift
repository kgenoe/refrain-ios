//
//  BlockingCollectionTableViewStructure.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-06-06.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation


enum BlockingCollectionSection: Int, TableViewSection {
    
    case Rules
    case Rename
    case Delete
    case ResetToDefaults
    
    /// Number of potentially available sections
    static var count: Int = {
        var max: Int = 0
        while let _ = BlockingCollectionSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static var all: [BlockingCollectionSection] = {
        var sections: [BlockingCollectionSection] = []
        var i = 0
        while let section = BlockingCollectionSection(rawValue: i) {
            i += 1
            sections.append(section)
        }
        return sections
    }()
}

enum BlockingCollectionRow: TableViewRow {
    case Rule(Int)
    case NewRule
    case Rename
    case Delete
    case ResetToDefaults
}

struct BlockingCollectionStructure: TableViewStructure {
    
    private var isDefaultCollection: Bool
    
    var sections = BlockingCollectionSection.all
    
    private var ruleRows: [BlockingCollectionRow] = []
    
    func rows(for section: BlockingCollectionSection) -> [BlockingCollectionRow] {
        switch section {
        case .Rules: return ruleRows
        case .Rename: return [.Rename]
        case .Delete: return [.Delete]
        case .ResetToDefaults: return [.ResetToDefaults]
        }
    }

    
    init(ruleCount: Int, isDefaultCollection: Bool) {
        self.isDefaultCollection = isDefaultCollection
        self.updateStructureFor(ruleCount: ruleCount)
    }
    
    mutating func updateStructureFor(ruleCount: Int) {
        
        sections = BlockingCollectionSection.all
        ruleRows = []
        for i in 0..<ruleCount {
            ruleRows.append(.Rule(i))
        }
        ruleRows.append(.NewRule)
        
        if isDefaultCollection {
            // Don't allow renaming of default collections
            sections = sections.filter{ $0 != .Rename }
        } else {
            sections = sections.filter{ $0 != .ResetToDefaults }
        }
    }
}
