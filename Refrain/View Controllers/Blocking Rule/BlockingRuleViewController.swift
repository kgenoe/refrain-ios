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
    
    @IBOutlet private weak var descriptionTextFieldView: UIView!
    
    @IBOutlet private weak var filterTextField: UITextField!
    
    @IBOutlet private weak var descriptionTextField: UITextField!

    
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
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
        saveButton.tintColor = UIColor(named: "White")
        navigationItem.rightBarButtonItem = saveButton
        
        // enable "background press to dismiss keyboard" behaviour
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundPressed))
        view.addGestureRecognizer(backgroundTap)
        
        filterTextField.delegate = self
        descriptionTextField.delegate = self
        
        if let rule = blockingRule {
            navigationItem.title = "Edit Rule"
            descriptionTextField.text = rule.ruleDescription
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
    }
    
    private func setBackgroundGradient() {
        view.layer.sublayers?.filter{ ($0 as? BackgroundGradientLayer) != nil }
            .forEach{ $0.removeFromSuperlayer() }
        
        let gradient = BackgroundGradientLayer(frame: view.bounds)
        view.layer.addSublayer(gradient)
    }
    
    private func setTextFieldInnerShadows() {
        
        filterTextFieldView.layer.sublayers?.filter{ ($0 as? InnerShadowLayer) != nil }.forEach{ $0.removeFromSuperlayer() }
        let filterInnerShadow = InnerShadowLayer(frame: filterTextFieldView.bounds.insetBy(dx: -20, dy: 0).offsetBy(dx: 10, dy: 0))
        filterTextFieldView.layer.addSublayer(filterInnerShadow)
        
        descriptionTextFieldView.layer.sublayers?.filter{ ($0 as? InnerShadowLayer) != nil }.forEach{ $0.removeFromSuperlayer() }
        let descriptionInnerShadow = InnerShadowLayer(frame: descriptionTextFieldView.bounds.insetBy(dx: -20, dy: 0).offsetBy(dx: 10, dy: 0))
        descriptionTextFieldView.layer.addSublayer(descriptionInnerShadow)
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
            let description = descriptionTextField.text ?? ""
            let newRule = BlockingRule(urlFilter: filter, ruleDescription: description)
            BlockingCollectionStore.shared.saveRule(newRule, to: blockingCollection)
        }
        
        // return to blocking collection
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backgroundPressed() {
        filterTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}


// Enable "press done to hide keyboard" behaviour
extension BlockingRuleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}