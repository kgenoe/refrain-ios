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
    
    
    
    //MARK: - Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        case .Blank:
            return HeaderTableViewCell(title: "")
        case .BlockingCollection(let i):
            let collection = BlockingCollectionStore.shared.collections[i]
            return BlockingCollectionCell(blockingCollection: collection)
        case .NewBlockingCollection:
            let cell = ItemTableViewCell(text: "+ New Collection", accessoryType: .none)
            return cell
        case .Schedules:
            return ItemTableViewCell(text: "Schedules")
        case .Settings:
            return ItemTableViewCell(text: "Settings")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch structure.rowType(for: indexPath) {
        case .BlockingCollection(let i):
            let collection = BlockingCollectionStore.shared.collections[i]
            collectionSelectedHandler?(collection)
        case .NewBlockingCollection:
            tableView.indexPathsForSelectedRows?.forEach {
                tableView.deselectRow(at: $0, animated: true)
            }
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
        case .BlockingCollection(_), .NewBlockingCollection, .Schedules, .Settings:
            return indexPath
        default:
            return nil
        }
    }
    
    /// Conditionally enable deletion for user created blocking collections
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch structure.rowType(for: indexPath) {
        case .BlockingCollection(_): return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch (editingStyle, structure.rowType(for: indexPath)) {
        case (.delete, .BlockingCollection(let i)):
            
            // delete the collection in the data store
            let collections = BlockingCollectionStore.shared.collections
            let collectionToDelete = collections[i]
            BlockingCollectionStore.shared.delete(collectionToDelete)
            
            // refresh the table view structure
            structure = MainTableViewStructure(collectionsCount: collections.count-1)
            
            // delete the table view cell
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default: break
        }
    }
}
