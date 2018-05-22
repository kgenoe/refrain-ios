//
//  PremiumUpgradeViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-05-22.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import StoreKit

let premiumUpgradeID = "premiumSubscription"

class PremiumUpgradeViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    
    static func instantiate() -> PremiumUpgradeViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PremiumUpgradeViewController") as! PremiumUpgradeViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAvailableProducts()
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
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        navigationItem.title = "Premium Upgrade"
        
        // set back button for next views
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
        
//        tableView.reloadData()
        
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
    
    
    
    //MARK: - IAPs
    
    var productsRequest = SKProductsRequest()
    var tipProducts = [SKProduct]()
    
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: premiumUpgradeID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseProduct(_ product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            print("PURCHASING: \(product.productIdentifier)")
        } else {
            let alertController = UIAlertController(title: "Whoops!", message: "Purchasses are disabled on your account or device.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Later", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
}



extension PremiumUpgradeViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        guard response.products.count == 1 else { return }
        
        let subscriptionProduct = response.products[0]
        
        // get its price from itunes connect
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = subscriptionProduct.priceLocale
        
        let priceString = numberFormatter.string(from: subscriptionProduct.price)
        priceLabel.text = priceString
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                
                let alertController = UIAlertController(title: "Success!", message: "You're now running Refrain with all features unlocked.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Done", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
                
            case .failed, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                
                let alertController = UIAlertController(title: "Whoops!", message: "Sorry, there was a problem connecting to iTunes.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Done", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            case .deferred, .purchasing:
                print("Defered/purchasing processing payment")
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let alertController = UIAlertController(title: "Purchases Restored", message: "Thanks again for your generous donation!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
