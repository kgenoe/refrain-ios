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
    
    func rateOnAppStorePressed() {
        let url = URL(string : "itms-apps://itunes.apple.com/app/id1079072933")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
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
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewStructure.rowType(for: indexPath) {
        case .PremiumFeatures:
            let upgradeVC = PremiumUpgradeViewController.instantiate()
            navigationController?.pushViewController(upgradeVC, animated: true)
        case .ReviewOnAppStore:
            rateOnAppStorePressed()
            tableView.indexPathsForSelectedRows?.forEach {
                tableView.deselectRow(at: $0, animated: true)
            }
        case .RequestFeature:
            showEmailViewController(subject: "Request a Feature", body: "")
        case .ReportProblem:
            showEmailViewController(subject: "Bug Report", body: "")
        default:
            break
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
        case .HowTo, .Feedback, .About: return 40
        default: return 0
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
        case .HowToEnable:
            return ItemTableViewCell(text: "How To Enable Refrain")
        case .HowToUse:
            return ItemTableViewCell(text: "How To Use Refrain")
        case .ReviewOnAppStore:
            return ItemTableViewCell(text: "Leave Us a Review")
        case .RequestFeature:
            return ItemTableViewCell(text: "Request a Feature")
        case .ReportProblem:
            return ItemTableViewCell(text: "Report a Problem or Bug")
        case .About:
            return ItemTableViewCell(text: "About")
        }
    }
}
