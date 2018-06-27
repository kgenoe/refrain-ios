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
    
    
    @IBOutlet weak var startTimeTextField: UITextField?
    
    @IBOutlet weak var endTimeTextField: UITextField?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tableViewStructure: BlockingScheduleStructure!
    
    
    private var previousDate = Date()
    
    private var datePicker = UIDatePicker()
    
    private var datePickerToolBar = UIToolbar()
    
    
    static func instantiate(blockingSchedule: BlockingSchedule? = nil) -> BlockingScheduleViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingScheduleViewController") as! BlockingScheduleViewController
        let defaultSchedule = BlockingSchedule(startTime: Date.defaultStart(), endTime: Date.defaultEnd())
        vc.blockingSchedule = blockingSchedule ?? defaultSchedule
        vc.editingExistingSchedule = (blockingSchedule != nil)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure date picker
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)

        // configure date picker toolbar
        let barButtonAttributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor(named: "Orange")!,
            .font: UIFont(name: "Avenir-Roman", size: 18.0)!
        ]
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateSelectionPressed))
        cancelButton.setTitleTextAttributes(barButtonAttributes, for: [])
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDateSelectionPressed))
        doneButton.setTitleTextAttributes(barButtonAttributes, for: [])
        
        datePickerToolBar = UIToolbar()
        datePickerToolBar.backgroundColor = UIColor.lightGray
        datePickerToolBar.setItems([cancelButton, space, doneButton], animated: false)
        datePickerToolBar.sizeToFit()

        
        // Configure tableview
        let collectionCount = BlockingCollectionStore.shared.collections.count
        tableViewStructure = BlockingScheduleStructure(collectionCount: collectionCount)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
        
        if editingExistingSchedule {
            navigationItem.title = "Edit Schedule"
        } else {
            navigationItem.title = "New Schedule"
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

   
    @objc func saveButtonPressed() {
        // save schedule
        BlockingScheduleStore.shared.save(blockingSchedule)
        
        // return to blocking collection
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - Date Selection
    @objc func startTimeDidBeginEditing() {
        previousDate = blockingSchedule.startTime
        datePicker.setDate(blockingSchedule.startTime, animated: false)
    }

    
    @objc func endTimeDidBeginEditing() {
        previousDate = blockingSchedule.endTime
        datePicker.setDate(blockingSchedule.endTime, animated: false)
    }
    
    
    @objc func pickerValueChanged(_ sender: UIDatePicker) {
        if startTimeTextField?.isFirstResponder ?? false {
            startTimeTextField?.text = sender.date.timeString()
            blockingSchedule.startTime = sender.date
        }
        if endTimeTextField?.isFirstResponder ?? false {
            endTimeTextField?.text = sender.date.timeString()
            blockingSchedule.endTime = sender.date
        }
    }
    
    @objc func cancelDateSelectionPressed() {
        if startTimeTextField?.isFirstResponder ?? false {
            startTimeTextField?.text = previousDate.timeString()
            blockingSchedule.startTime = previousDate
        }
        if endTimeTextField?.isFirstResponder ?? false {
            endTimeTextField?.text = previousDate.timeString()
            blockingSchedule.endTime = previousDate
        }

        startTimeTextField?.resignFirstResponder()
        endTimeTextField?.resignFirstResponder()
    }
    
    
    @objc func doneDateSelectionPressed() {
        startTimeTextField?.resignFirstResponder()
        endTimeTextField?.resignFirstResponder()
    }
}


//MARK: - UITableView
extension BlockingScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewStructure.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewStructure.rowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewStructure.rowType(for: indexPath) {
        case .StartTimeHeader:
            return HeaderTableViewCell(title: "Start Time")
        case .StartTime:
            let cell = TextFieldTableViewCell(text: blockingSchedule.startTime.timeString())
            self.startTimeTextField = cell.textField
            self.startTimeTextField?.inputView = datePicker
            self.startTimeTextField?.inputAccessoryView = datePickerToolBar
            self.startTimeTextField?.addTarget(self, action: #selector(startTimeDidBeginEditing), for: .editingDidBegin)
            return cell
        case .EndTimeHeader:
            return HeaderTableViewCell(title: "End Time")
        case .EndTime:
            let cell = TextFieldTableViewCell(text: blockingSchedule.endTime.timeString())
            self.endTimeTextField = cell.textField
            self.endTimeTextField?.inputView = datePicker
            self.endTimeTextField?.inputAccessoryView = datePickerToolBar
            self.endTimeTextField?.addTarget(self, action: #selector(endTimeDidBeginEditing), for: .editingDidBegin)
            return cell
        case .CollectionsHeader:
            return HeaderTableViewCell(title: "Apply To Collections")
        case .Collection(let i):
            let collection = BlockingCollectionStore.shared.collections[i]
            return BlockingScheduleCollectionCell.instantiate(from: tableView, schedule: blockingSchedule, blockingCollection: collection)
        }
    }
}



