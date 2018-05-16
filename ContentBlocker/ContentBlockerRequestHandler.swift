//
//  ContentBlockerRequestHandler.swift
//  ContentBlocker
//
//  Created by Kyle on 2018-04-20.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        
        let fileManager = FileManager.default
        let appGroup = "group.ca.genoe.Refrain"
        guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Error reaching Refrain shared container.")
            return
        }
        let path = container.appendingPathComponent("blockerList.json")

        let attachment = NSItemProvider(contentsOf: path)!
        let item = NSExtensionItem()
        item.attachments = [attachment as Any]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
