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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // check for updated version of blocking collection from store
        if let updatedBlockingCollection = BlockingCollectionStore.shared.collections.first(where: { $0.id == blockingCollection.id }) {
            blockingCollection = updatedBlockingCollection
        }
        
        // style the view for the updated blocking collection
        navigationItem.title = blockingCollection.name
        
        // set back button for next view (BlockingRuleView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        
        tableView.reloadData()

        setBackgroundGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        BlockingCollectionStore.shared.saveCollection(blockingCollection)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            blockingCollection.rules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < blockingCollection.rules.count {
            let rule = blockingCollection.rules[indexPath.row]
            let editRuleVC = BlockingRuleViewController.instantiate(blockingCollection: blockingCollection, blockingRule: rule)
            navigationController?.pushViewController(editRuleVC, animated: true)
        } else {
            BlockingCollectionStore.shared.delete(blockingCollection)
            closeButtonPressed()
        }
    }
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockingCollection.rules.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < blockingCollection.rules.count {
            let rule = blockingCollection.rules[indexPath.row]
            return BlockingRuleCell(blockingCollection: blockingCollection, blockingRule: rule)
        } else {
            let cell = HeaderTableViewCell(title: "Delete collection")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        }
    }
    
}
