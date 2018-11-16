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
        app.launchArguments += ["screenshots"]
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        snapshot("01Main")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Social Media"]/*[[".cells.matching(identifier: \"0\").staticTexts[\"Social Media\"]",".staticTexts[\"Social Media\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("02Collection")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["facebook.com"]/*[[".cells.matching(identifier: \"1\").staticTexts[\"facebook.com\"]",".staticTexts[\"facebook.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements.staticTexts["Regular Expression Syntax"].tap()
        snapshot("03Rule")
    }

}
