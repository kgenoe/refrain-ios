//
//  BlockingCollectionViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingCollectionViewController: UIViewController {
    
    var blockingCollection: BlockingCollection!
    
    var tableViewStructure: BlockingCollectionStructure!
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Instantiate a BlockingCollectionViewController from a BlockingCollection. If a nil BlockingCollection is provided, a prompt is displayed to create one to populate this view
    static func instantiate(blockingCollection: BlockingCollection) -> BlockingCollectionViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingCollectionViewController") as! BlockingCollectionViewController
        vc.blockingCollection = blockingCollection
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        
        // check for updated version of blocking collection from store
        if let updatedBlockingCollection = BlockingCollectionStore.shared.collections.first(where: { $0.id == blockingCollection.id }) {
            blockingCollection = updatedBlockingCollection
        }
        
        let ruleCount = blockingCollection.rules.count
        tableViewStructure = BlockingCollectionStructure(ruleCount: ruleCount, isDefaultCollection: blockingCollection.isDefault)
            
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        // style the view for the updated blocking collection
        navigationItem.title = blockingCollection.name
        
        // set back button for next view (BlockingRuleView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        

        setBackgroundGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't save blockingCollection if it's been deleted
        if BlockingCollectionStore.shared.collections.contains(where: { $0.id == blockingCollection.id} ) {
            BlockingCollectionStore.shared.saveCollection(blockingCollection)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setBackgroundGradient()
    }
    
    private func setBackgroundGradient() {
        view.layer.sublayers?.filter{ ($0 as? BackgroundGradientLayer) != nil }
            .forEach{ $0.removeFromSuperlayer() }
        
        let gradient = BackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradient)
    }
    
    @IBAction func closeButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newBlockingRuleButtonPressed() {
        guard let collection = blockingCollection else { return }
        let newRuleVC = BlockingRuleViewController.instantiate(blockingCollection: collection)
        navigationController?.pushViewController(newRuleVC, animated: true)
    }
    
    
    
    // MARK: - Delete Alert
    private func presentDeleteAlert() {
        let alert = UIAlertController(title: "Are you sure you want to delete this collection?", message: nil, preferredStyle: .actionSheet)
        alert.setBackgroundColor(.white)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            BlockingCollectionStore.shared.delete(self.blockingCollection)
            self.closeButtonPressed()
        })
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Reset To Default Alert
    private func presentResetToDefaultAlert() {
        let alert = UIAlertController(title: "Reset this collection?", message: "Any changes that have been made to this collection will be lost as a result.", preferredStyle: .actionSheet)
        alert.setBackgroundColor(.white)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
            DefaultBlockingCollections().restoreDefaultCollectionToDefault(collection: self.blockingCollection)
            self.setupView()
        })
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Rename Alert
    var alert: UIAlertController?
    
    private func presentRenameAlert() {
        alert = UIAlertController(title: "Rename Blocking Collection", message: "Enter a new name for this collection of blocked websites", preferredStyle: .alert)
        
        alert?.addTextField(configurationHandler: nil)
        alert?.textFields?[0].addTarget(self, action: #selector(alertTextDidChange), for: .editingChanged)
        alert?.textFields?[0].text = self.blockingCollection.name
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert?.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Rename", style: .default, handler: { (action) in
            self.blockingCollection.name = self.alert?.textFields?.first?.text ?? ""
            self.navigationItem.title = self.blockingCollection.name
        })
        saveAction.isEnabled = false
        saveAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert?.addAction(saveAction)
        
        present(alert!, animated: true, completion: nil)
    }
    
    @objc func alertTextDidChange() {
        guard let alert = alert else { return }
        
        if alert.textFields?[0].text ?? "" == "" {
            alert.actions[1].isEnabled = false
        } else {
            alert.actions[1].isEnabled = true
        }
    }
    
}



extension BlockingCollectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
    /// Conditionally enable deletion for some table view rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch (blockingCollection.isDefault, tableViewStructure.rowType(for: indexPath)) {
        case (false, .Rule(_)): return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let rowType = tableViewStructure.rowType(for: indexPath)
        switch (editingStyle, rowType) {
        case (.delete, .Rule(let i)):
            
            // delete the rule in the store
            blockingCollection.rules.remove(at: i)
            BlockingCollectionStore.shared.saveCollection(blockingCollection)
            
            // refresh the table view structure
            tableViewStructure.updateStructureFor(ruleCount: blockingCollection.rules.count)
            
            // delete the table view cell
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default: break
        }
    }
    
    
    
    /// Conditionally disable selection for some table view rows
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch tableViewStructure.rowType(for: indexPath) {
        case .Rule(_), .NewRule, .Rename, .Delete, .ResetToDefaults:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewStructure.rowType(for: indexPath) {
        case .Rule(let i):
            let rule = blockingCollection.rules[i]
            let editRuleVC = BlockingRuleViewController.instantiate(blockingCollection: blockingCollection, blockingRule: rule)
            navigationController?.pushViewController(editRuleVC, animated: true)
        case .NewRule:
            newBlockingRuleButtonPressed()
        case .Rename:
            presentRenameAlert()
            tableView.deselectRow(at: indexPath, animated: true)
        case .Delete:
            presentDeleteAlert()
            tableView.deselectRow(at: indexPath, animated: true)
        case .ResetToDefaults:
            presentResetToDefaultAlert()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewStructure.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewStructure.rowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewStructure.rowType(for: indexPath) {
        case .Rule(let i):
            let rule = blockingCollection.rules[i]
            return BlockingRuleCell(blockingCollection: blockingCollection, blockingRule: rule)
        case .NewRule:
            return ItemTableViewCell(text: "+ New URL", accessoryType: .none)
        case .Rename:
            let cell = ItemTableViewCell(text: "Rename Collection", accessoryType: .none)
            cell.textLabel?.textAlignment = .center
            return cell
        case .Delete:
            let cell = ItemTableViewCell(text: "Delete Collection", accessoryType: .none)
            cell.textLabel?.textAlignment = .center
            return cell
        case .ResetToDefaults:
            let cell = ItemTableViewCell(text: "Reset To Default", accessoryType: .none)
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
}
