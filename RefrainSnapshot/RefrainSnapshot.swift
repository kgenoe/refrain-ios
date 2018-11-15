//
//  RefrainSnapshot.swift
//  RefrainSnapshot
//
//  Created by Kyle on 2018-11-15.
//  Copyright © 2018 Kyle. All rights reserved.
//

import XCTest

class RefrainSnapshot: XCTestCase {

    override func setUp() {

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        //        snapshot("FirstScreenshot")
    }

}
