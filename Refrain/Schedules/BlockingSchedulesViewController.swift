//
//  BlockingScheduleListViewController.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingSchedulesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Blocking Schedules"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newBlockingScheduleButtonPressed() {
        let newScheduleVC = BlockingScheduleViewController.instantiate()
        navigationController?.pushViewController(newScheduleVC, animated: true)
    }

}


extension BlockingSchedulesViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let scheduleToDelete = BlockingScheduleStore.shared.schedules[indexPath.row]
            BlockingScheduleStore.shared.delete(scheduleToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = BlockingScheduleStore.shared.schedules[indexPath.row]
        let editScheduleVC = BlockingScheduleViewController.instantiate(blockingSchedule: schedule)
        navigationController?.pushViewController(editScheduleVC, animated: true)
    }
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlockingScheduleStore.shared.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let schedule = BlockingScheduleStore.shared.schedules[indexPath.row]
        return BlockingSchedueCell.instantiate(from: tableView, blockingSchedule: schedule)
    }
}
