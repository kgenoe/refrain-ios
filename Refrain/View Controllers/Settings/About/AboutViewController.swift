//
//  AboutViewController.swift
//  Refrain
//
//  Created by Kyle on 2018-11-12.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    static func instantiate() -> AboutViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "About Refrain"
        
    
        let text = """
Refrain is meant to be used to block unhelpful websites from your device. That can mean different things to different people, but here are some suggestions on how to use it effectively:

 - Block distracting websites to help you stay focused while working
 - Block addictive websites that you compulsively check though out the day, to curb device addiction
 - Block news or political websites to disconnect from the anxiety-inducing news cycle for a while

For additional ways to lock down your devices, look into iOS’s Screen Time feature, as it offers many system level controls that go beyond what apps like Refrain can do.

Refrain is developed by me, Kyle Genoe, in my spare time. If you find Refrain useful, please consider donating to fund further development, any amount helps.

Developed in Toronto with love.
"""
        aboutTextView.text = text

        // set version & copyright label
        var bottomText = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            bottomText = "v\(version) (\(build))\n"
        }
        
        bottomText += "© 2015-2018 Kyle Genoe"
        bottomLabel.text = bottomText
    }

}
