//
//  TableViewStructure.swift
//  zoocasa-ios
//
//  Created by Kyle Genoe on 2018-05-30.
//  Copyright © 2018 Zoocasa Reality Inc. All rights reserved.
//

import Foundation

protocol TableViewSection {
    static var all: [Self] {get}
}


protocol TableViewRow {
    
}


protocol TableViewStructure {
    
    associatedtype SectionType: TableViewSection
    associatedtype RowType: TableViewRow
    
    // Implementations required
    var sections: [SectionType] {get}
    func rows(for section: SectionType) -> [RowType]

    // Implementations optional
    var sectionCount: Int {get}
    func sectionType(for section: Int) -> SectionType
    
    func rowCount(for section: Int) -> Int
    func rowType(for indexPath: IndexPath) -> RowType
}

extension TableViewStructure {

    // Returns the number of items in the *sections* property. This is the default implementation of sectionCount.
    var sectionCount: Int { return sections.count }

    /// Returns the section type value in *sections* at the provided index. This is the default implementation of sectionType(for section: Int).
    func sectionType(for section: Int) -> SectionType {
        return sections[section]
    }
    
    /// Returns the number of rows for the section at the provided index (using sectionType(for section: SectionType) & rows(for section: SectionType)). Meant to be used in UITableViewDataSource function numberOfRowsInSection. This is the default implementation of rowCount(for section: Int).
    func rowCount(for section: Int) -> Int {
        let section = sectionType(for: section)
        return rows(for: section).count
    }

    /// Returns the row type for the row at the provided IndexPath (using sectionType(for section: SectionType) & rows(for section: SectionType)). Meant to be used in UITableViewDataSource function cellForRowAtIndexPath. This is the default implementation of rowType(for indexPath: IndexPath).
    func rowType(for indexPath: IndexPath) -> RowType {
        let section = sectionType(for: indexPath.section)
        let rows = self.rows(for: section)
        return rows[indexPath.row]
    }
}
