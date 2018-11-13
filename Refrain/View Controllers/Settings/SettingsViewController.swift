//
//  SettingsViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-05-22.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    private var tableViewStructure = SettingsTableViewStructure()
    
    @IBOutlet weak var tableView: UITableView!
    
    static func instantiate() -> SettingsViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
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
        
        navigationItem.title = "Settings"
        
        // set back button for next views
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        
        tableView.reloadData()
        
        setBackgroundGradient()
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
    
    
    //MARK: - Rate On App Store
    func rateOnAppStorePressed() {
        let url = URL(string : "itms-apps://itunes.apple.com/app/id1079072933")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    //MARK: - Email Message View
    private func showEmailViewController(subject: String, body: String) {

        UINavigationBar.appearance().titleTextAttributes = [:]
        UINavigationBar.appearance().prefersLargeTitles = false
        UIBarButtonItem.appearance().setTitleTextAttributes([:], for: [])
        
        let mailVC = MFMailComposeViewController()
        mailVC.additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        mailVC.mailComposeDelegate = self
        mailVC.setSubject(subject)
        mailVC.setMessageBody(body, isHTML: false)
        mailVC.setToRecipients(["kyle@genoe.ca"])
        present(mailVC, animated: true, completion: nil)
        
        AppearanceManager().configure()
    }
    
    
    //MARK: - Restore Original Collections Alert
    private func presentRestoreOriginalCollectionsAlert() {

        let defaultCollectionNames = DefaultBlockingCollections().defaultCollectionTitles
        let defaultCollectionsString = defaultCollectionNames.joined(separator: ", ")

        let alert = UIAlertController(title: "Restore Original Collections?", message: "Any changes made to \(defaultCollectionsString) will be lost.", preferredStyle: .actionSheet)
        alert.setBackgroundColor(.white)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let restoreAction = UIAlertAction(title: "Restore", style: .destructive, handler: { (action) in
            DefaultBlockingCollections().restoreAllDefaultCollections()
            self.navigationController?.popViewController(animated: true)
        })
        restoreAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(restoreAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Shortcuts
    private func presentDeleteAllShortcutsAlert() {
        
        let alert = UIAlertController(title: "Delete all Siri Shortcuts for Refrain?", message: nil, preferredStyle: .actionSheet)
        alert.setBackgroundColor(.white)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Orange"), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let restoreAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            IntentsManager.shared.deleteAll()
        })
        restoreAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(restoreAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect the selected row
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
        
        switch tableViewStructure.rowType(for: indexPath) {
        case .PremiumFeatures:
            let upgradeVC = PremiumUpgradeViewController.instantiate()
            navigationController?.pushViewController(upgradeVC, animated: true)
        case .RestoreOriginalCollections:
            presentRestoreOriginalCollectionsAlert()
        case .ReviewOnAppStore:
            rateOnAppStorePressed()
        case .RequestFeature:
            showEmailViewController(subject: "Request a Feature", body: "")
        case .ReportProblem:
            showEmailViewController(subject: "Bug Report", body: "")
        case .DeleteAllSiriShortcuts:
            presentDeleteAllShortcutsAlert()
        case .About:
            let aboutVC = AboutViewController.instantiate()
            navigationController?.pushViewController(aboutVC, animated: true)
        case .Donation:
            let donateVC = DonateViewController.instantiate()
            navigationController?.pushViewController(donateVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Section Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableViewStructure.sectionType(for: section) {
        case .PremiumFeatures: return 0
        default: return 40
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
        case .PremiumFeatures:
            return ItemTableViewCell(text: "Premium Features")
        case .RestoreOriginalCollections:
            return ItemTableViewCell(text: "Restore Original Collections")
        case .ReviewOnAppStore:
            return ItemTableViewCell(text: "Leave Us a Review")
        case .RequestFeature:
            return ItemTableViewCell(text: "Request a Feature")
        case .ReportProblem:
            return ItemTableViewCell(text: "Report a Problem or Bug")
        case .DeleteAllSiriShortcuts:
            return ItemTableViewCell(text: "Delete All Siri Shortcuts")
        case .About:
            return ItemTableViewCell(text: "About")
        case .Donation:
            return ItemTableViewCell(text: "Donate")
        }
    }
}
