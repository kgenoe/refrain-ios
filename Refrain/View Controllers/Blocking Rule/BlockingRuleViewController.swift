//
//  BlockingRuleViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-01-23.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class BlockingRuleViewController: UIViewController {

    var blockingList: BlockingList!
    
    var blockingRule: BlockingRule?
    
    @IBOutlet private weak var filterTextFieldView: UIView!
    
    @IBOutlet private weak var descriptionTextFieldView: UIView!
    
    @IBOutlet private weak var filterTextField: UITextField!
    
    @IBOutlet private weak var descriptionTextField: UITextField!

    
    static func instantiate(blockingList: BlockingList, blockingRule: BlockingRule? = nil) -> BlockingRuleViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlockingRuleViewController") as! BlockingRuleViewController
        vc.blockingList = blockingList
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
        
        if let rule = blockingRule {
            navigationItem.title = "Edit Rule"
            descriptionTextField.text = rule.ruleDescription
            filterTextField.text = rule.urlFilter
        } else {
            navigationItem.title = "New Rule"
        }
        
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
            BlockingListStore.shared.saveRule(updatedRule, to: blockingList)
        }
        // Save new rule
        else {
            let filter = filterTextField.text ?? ""
            let description = descriptionTextField.text ?? ""
            let newRule = BlockingRule(urlFilter: filter, ruleDescription: description)
            BlockingListStore.shared.saveRule(newRule, to: blockingList)
        }
        
        // return to blocking list
        navigationController?.popViewController(animated: true)
    }
}
