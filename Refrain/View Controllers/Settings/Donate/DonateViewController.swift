//
//  DonateViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-11-12.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import SafariServices

class DonateViewController: UIViewController {
    
    
    @IBOutlet weak var tip1Button: UIBorderedButton!
    @IBOutlet weak var tip2Button: UIBorderedButton!
    @IBOutlet weak var tip3Button: UIBorderedButton!
    @IBOutlet weak var restorePurchasesButton: UIBorderedButton!
    @IBOutlet weak var tweetButton: UIBorderedButton!
    @IBOutlet weak var emailButton: UIBorderedButton!

    static func instantiate() -> DonateViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DonateViewController") as! DonateViewController
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Donate"
        
        tip1Button.borderColor = UIColor(named: "Orange")!
        tip2Button.borderColor = UIColor(named: "Orange")!
        tip3Button.borderColor = UIColor(named: "Orange")!
        restorePurchasesButton.borderColor = UIColor(named: "Orange")!
        tweetButton.borderColor = UIColor(named: "Orange")!
        emailButton.borderColor = UIColor(named: "Orange")!
        
        setBackgroundGradient()
        
        fetchAvailableProducts()
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
        let productIdentifiers = NSSet(objects: tip1ID, tip2ID, tip3ID)
        
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
    
    
    
    //MARK: - UI Actions    
    @IBAction func tip1Pressed() {
        self.purchaseProduct(tipProducts[0])
    }
    
    @IBAction func tip2Pressed() {
        self.purchaseProduct(tipProducts[1])
    }
    
    @IBAction func tip3Pressed() {
        self.purchaseProduct(tipProducts[2])
    }
    
    @IBAction func restorePurchasesPressed() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func tweetButtonPressed() {
        let twitterURL = URL(string: "https://twitter.com/kylegenoe")!
        let safariVC = SFSafariViewController(url: twitterURL)
        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonPressed() {
        if !MFMailComposeViewController.canSendMail() { return }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["kyle@genoe.ca"])
        composeVC.setSubject("Refrain - Customer Support")
        self.present(composeVC, animated: true, completion: nil)
    }
}


extension DonateViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension DonateViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
 
        print("Fetched products: \(response.products.count)")
        self.tipProducts = response.products
        
        let firstProduct = response.products[0]
        let secondProduct = response.products[1]
        let thirdProduct = response.products[2]
        
        // get its price from itunes connect
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = firstProduct.priceLocale
        
        let tip1PriceString = numberFormatter.string(from: firstProduct.price)
        tip1Button.setTitle(tip1PriceString, for: [])
        
        let tip2PriceString = numberFormatter.string(from: secondProduct.price)
        tip2Button.setTitle(tip2PriceString, for: [])
        
        let tip3PriceString = numberFormatter.string(from: thirdProduct.price)
        tip3Button.setTitle(tip3PriceString, for: [])
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                
                let alertController = UIAlertController(title: "Donation Recieved!", message: "Thanks again for your generous donation!", preferredStyle: .alert)
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

