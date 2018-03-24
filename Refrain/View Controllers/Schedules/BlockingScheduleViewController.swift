//
//  BlockingScheduleViewController.swift
//  Refrain
//
//  Created by Kyle Genoe on 2018-02-01.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingScheduleViewController: UIViewController {

    fileprivate var blockingSchedule: BlockingSchedule!
    
    fileprivate var editingExistingSchedule: Bool!
    
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var datePicker: UIDatePicker?
    
    
    static func instantiate(blockingSchedule: BlockingSchedule? = nil) -> BlockingScheduleViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingScheduleViewController") as! BlockingScheduleViewController
        let defaultSchedule = BlockingSchedule(startTime: Date.defaultStart(), endTime: Date.defaultEnd())
        vc.blockingSchedule = blockingSchedule ?? defaultSchedule
        vc.editingExistingSchedule = (blockingSchedule != nil)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
        
        if editingExistingSchedule {
            navigationItem.title = "Edit Schedule"
        } else {
            navigationItem.title = "New Schedule"
        }
        
        
        startTimeTextField.text = blockingSchedule.startTime.timeString()
        endTimeTextField.text = blockingSchedule.endTime.timeString()
    }

   
    @objc func saveButtonPressed() {
        // save schedule
        BlockingScheduleStore.shared.save(blockingSchedule)
        
        // return to blocking list
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func startTimeDidBeginEditing() {
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .time
        datePicker!.setDate(blockingSchedule.startTime, animated: false)
        startTimeTextField.inputView = datePicker!

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateSelection))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishedPickingStartTime))
        let toolBar = UIToolbar()
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.sizeToFit()
        startTimeTextField.inputAccessoryView = toolBar
    }
    
    
    @IBAction func endTimeDidBeginEditing() {
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .time
        datePicker!.setDate(blockingSchedule.endTime, animated: false)
        endTimeTextField.inputView = datePicker!
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateSelection))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishedPickingEndTime))
        let toolBar = UIToolbar()
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.sizeToFit()
        endTimeTextField.inputAccessoryView = toolBar
    }
    
    
    
    @objc func cancelDateSelection() {
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
    
    
    @objc func finishedPickingStartTime(){
        startTimeTextField.resignFirstResponder()
        blockingSchedule.startTime = datePicker!.date
        startTimeTextField.text = datePicker!.date.timeString()
        datePicker = nil
    }
    
    @objc func finishedPickingEndTime() {
        endTimeTextField.resignFirstResponder()
        blockingSchedule.endTime = datePicker!.date
        endTimeTextField.text = datePicker!.date.timeString()
        datePicker = nil
    }
}



extension BlockingScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlockingListStore.shared.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = BlockingListStore.shared.lists[indexPath.row]
        return BlockingScheduleListCell.instantiate(from: tableView, schedule: blockingSchedule, blockingList: list)
    }
}



