//
//  BlockingSchedulesCollectionViewController.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import UserNotifications

class BlockingSchedulesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    static func instantiate() -> BlockingSchedulesViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingSchedulesViewController") as! BlockingSchedulesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if !UserDefaults.standard.bool(forKey: DefaultsKey.notifSplashShown) {
            UserDefaults.standard.set(true, forKey: DefaultsKey.notifSplashShown)
            let notifSplashVC = NotificationsSplashViewController.instantiate()
            present(notifSplashVC, animated: true, completion: nil)
        }
        
        // set back button for next view (BlockingScheduleView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Blocking Schedules"
        
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // style view for unauthorized notifications here
            }
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
        return BlockingSchedueCell(blockingSchedule: schedule)
    }
}
