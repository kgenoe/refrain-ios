//
//  BlockingCollectionTableViewStructure.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-06-06.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation


enum BlockingCollectionSection: Int, TableViewSection {
    
    case Enabled
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
    case EnabledSwitch
    case Rule(Int)
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
        case .Enabled: return [.EnabledSwitch]
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
        // Remove rules section if 0 rules
        guard ruleCount > 0 else {
            sections = sections.filter{ $0 != .Rules }
            return
        }
        
        sections = BlockingCollectionSection.all
        ruleRows = []
        for i in 0..<ruleCount {
            ruleRows.append(.Rule(i))
        }
        
        if isDefaultCollection {
            sections = sections.filter{ $0 != .Rename }
            sections = sections.filter{ $0 != .Delete }
        } else {
            sections = sections.filter{ $0 != .ResetToDefaults }
        }
    }
}
