//
//  BlockingListViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingListViewController: UIViewController {

    var blockingList: BlockingList!
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Instantiate a BlockingListViewController from a BlockingList. If a nil BlockingList is provided, a prompt is displayed to create one to populate this view
    static func instantiate(blockingList: BlockingList) -> BlockingListViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingListViewController") as! BlockingListViewController
        vc.blockingList = blockingList
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
        
        // check for updated version of blocking list from store
        if let updatedBlockingList = BlockingListStore.shared.lists.first(where: { $0.id == blockingList.id }) {
            blockingList = updatedBlockingList
        }
        
        // style the view for the updated blocking list
        navigationItem.title = blockingList.name
        
        // set back button for next view (BlockingRuleView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        
        tableView.reloadData()

        setBackgroundGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        BlockingListStore.shared.saveList(blockingList)
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newBlockingRuleButtonPressed() {
        guard let list = blockingList else { return }
        let newRuleVC = BlockingRuleViewController.instantiate(blockingList: list)
        navigationController?.pushViewController(newRuleVC, animated: true)
    }
}



extension BlockingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
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
            blockingList.rules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < blockingList.rules.count {
            let rule = blockingList.rules[indexPath.row]
            let editRuleVC = BlockingRuleViewController.instantiate(blockingList: blockingList, blockingRule: rule)
            navigationController?.pushViewController(editRuleVC, animated: true)
        } else {
            BlockingListStore.shared.delete(blockingList)
            closeButtonPressed()
        }
    }
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockingList.rules.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < blockingList.rules.count {
            let rule = blockingList.rules[indexPath.row]
            return BlockingRuleCell(blockingList: blockingList, blockingRule: rule)
        } else {
            let cell = HeaderTableViewCell(title: "Delete list")
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.textColor = UIColor(named: "Orange")
            return cell
        }
    }
    
}
