//
//  BlockingRuleViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingRuleViewController: UIViewController {

    var blockingCollection: BlockingCollection!
    
    var blockingRule: BlockingRule?
    
    @IBOutlet private weak var filterTextFieldView: UIView!
    
    @IBOutlet private weak var filterTextField: UITextField!
    
    
    @IBOutlet private weak var rule1Label: UILabel!
    @IBOutlet private weak var rule2Label: UILabel!
    @IBOutlet private weak var rule3Label: UILabel!
    @IBOutlet private weak var rule4Label: UILabel!
    @IBOutlet private weak var rule5Label: UILabel!
    @IBOutlet private weak var rule6Label: UILabel!
    @IBOutlet private weak var rule7Label: UILabel!
    @IBOutlet private weak var rule8Label: UILabel!
    
    @IBOutlet private weak var rule1LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule2LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule3LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule4LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule5LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule6LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule7LabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var rule8LabelHeight: NSLayoutConstraint!

    
    static func instantiate(blockingCollection: BlockingCollection, blockingRule: BlockingRule? = nil) -> BlockingRuleViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingRuleViewController") as! BlockingRuleViewController
        vc.blockingCollection = blockingCollection
        vc.blockingRule = blockingRule
        return vc
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        saveButton.tintColor = UIColor(named: "White")
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        cancelButton.tintColor = UIColor(named: "White")
        navigationItem.backBarButtonItem = cancelButton
        
        // enable "background press to dismiss keyboard" behaviour
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundPressed))
        view.addGestureRecognizer(backgroundTap)
        
        filterTextField.delegate = self
        
        if let rule = blockingRule {
            navigationItem.title = "Edit Rule"
            filterTextField.text = rule.urlFilter
        } else {
            navigationItem.title = "New Rule"
        }
        
    }
    
    // Used to automatically show keyboard when appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBackgroundGradient()
        setTextFieldInnerShadows()
        adjustLabelHeightsForContent()
    }
    
    private func setBackgroundGradient() {
        view.layer.sublayers?.filter{ ($0 as? BackgroundGradientLayer) != nil }
            .forEach{ $0.removeFromSuperlayer() }
        
        let gradient = BackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradient)
    }
    
    private func setTextFieldInnerShadows() {
        
        filterTextFieldView.layer.sublayers?.filter{ ($0 as? InnerShadowLayer) != nil }.forEach{ $0.removeFromSuperlayer() }
        let filterInnerShadow = InnerShadowLayer(frame: filterTextFieldView.bounds.insetBy(dx: -2, dy: 0).offsetBy(dx: 1, dy: 0))
        filterTextFieldView.clipsToBounds = true
        filterTextFieldView.layer.addSublayer(filterInnerShadow)
    }
    
    private func adjustLabelHeightsForContent() {
        rule1LabelHeight.constant = rule1Label.intrinsicContentSize.height
        rule2LabelHeight.constant = rule2Label.intrinsicContentSize.height
        rule3LabelHeight.constant = rule3Label.intrinsicContentSize.height
        rule4LabelHeight.constant = rule4Label.intrinsicContentSize.height
        rule5LabelHeight.constant = rule5Label.intrinsicContentSize.height
        rule6LabelHeight.constant = rule6Label.intrinsicContentSize.height
        rule7LabelHeight.constant = rule7Label.intrinsicContentSize.height
        rule8LabelHeight.constant = rule8Label.intrinsicContentSize.height
    }

    @objc func saveButtonPressed() {
        
        // Do checks on URL filter here
//        guard filter == formatedProperly() else { return }
        
        // Patch existing rule
        if let updatedRule = blockingRule {
            BlockingCollectionStore.shared.saveRule(updatedRule, to: blockingCollection)
        }
        // Save new rule
        else {
            let filter = filterTextField.text ?? ""
            let newRule = BlockingRule(urlFilter: filter)
            BlockingCollectionStore.shared.saveRule(newRule, to: blockingCollection)
        }
        
        // return to blocking collection
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backgroundPressed() {
        filterTextField.resignFirstResponder()
    }
}


// Enable "press done to hide keyboard" behaviour
extension BlockingRuleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        return false
    }
}
