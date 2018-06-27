//
//  MainTableViewDelegate.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-06-06.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class MainTableViewDelegate: NSObject {
    
    var structure: MainTableViewStructure
    
    var collectionSelectedHandler: ((BlockingCollection) -> Void)?
    
    var newCollectionSelectedHandler: (() -> Void)?
    
    var schedulesSelectedHandler: (() -> Void)?
    
    var settingsSelectedHandler: (() -> Void)?
    
    init(structure: MainTableViewStructure) {
        self.structure = structure
        super.init()
    }
}

extension MainTableViewDelegate: UITableViewDelegate {
    
    // MARK: - Section Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch structure.sectionType(for: section) {
        case .Schedules, .Settings: return 40
        default: return 0
        }
    }
}


extension MainTableViewDelegate: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return structure.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structure.rowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch structure.rowType(for: indexPath) {
        case .UserBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ !$0.isDefault }[i]
            return BlockingCollectionCell(blockingCollection: collection)
        case .NewUserBlockingCollection:
            let cell = HeaderTableViewCell(title: "New Blocking Collection")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        case .DefaultBlockingCollectionsHeader:
            return HeaderTableViewCell(title: "Default Collections")
        case .DefaultBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ $0.isDefault }[i]
            return BlockingCollectionCell(blockingCollection: collection)
        case .Schedules:
            return ItemTableViewCell(text: "Schedules")
        case .Settings:
            return ItemTableViewCell(text: "Settings")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch structure.rowType(for: indexPath) {
        case .DefaultBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ $0.isDefault }[i]
            collectionSelectedHandler?(collection)
        case .UserBlockingCollections(let i):
            let collection = BlockingCollectionStore.shared.collections.filter{ !$0.isDefault }[i]
            collectionSelectedHandler?(collection)
        case .NewUserBlockingCollection:
            newCollectionSelectedHandler?()
        case .Schedules:
            schedulesSelectedHandler?()
        case .Settings:
            settingsSelectedHandler?()
        default:
            break
        }
    }
    
    
    /// Conditionally disable selection for some table view rows
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch structure.rowType(for: indexPath) {
        case .DefaultBlockingCollections(_), .UserBlockingCollections(_), .NewUserBlockingCollection, .Schedules, .Settings:
            return indexPath
        default:
            return nil
        }
    }
    
    /// Conditionally enable deletion for user created blocking collections
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch structure.rowType(for: indexPath) {
        case .UserBlockingCollections(_): return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle, structure.rowType(for: indexPath)) {
        case (.delete, .UserBlockingCollections(let i)):
            
            // delete the collection in the data store
            let collections = BlockingCollectionStore.shared.collections
            let userCreatedCollections = collections.filter{ $0.isDefault == false }
            let collectionToDelete = userCreatedCollections[i]
            BlockingCollectionStore.shared.delete(collectionToDelete)
            
            // refresh the table view structure
            let defaultCount = collections.filter{ $0.isDefault }.count
            structure = MainTableViewStructure(defaultCollectionsCount: defaultCount, userCollectionsCount: userCreatedCollections.count-1)
            
            // delete the table view cell
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default: break
        }
    }
}
