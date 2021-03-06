//
// Copyright (C) 2016 Jared Perry, Jaron Somers, Warren Barnes, Scott Weidenkopf, and Grant Grimm
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies
// or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
// THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//  NavDrawerTableViewControllerTests.swift
//  Rivergreenway
//
//  Created by Scott Weidenkopf on 2/15/16.
//  Copyright © 2016 City of Fort Wayne Greenways and Trails Department. All rights reserved.
//

import XCTest

class NavDrawerViewControllerTests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app!.buttons["Login"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSealDisplayed() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        assert(app!.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.isHittable)
    }
    
    func testRecordActivityNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Record Activity").children(matching: .staticText).matching(identifier: "Record Activity").element(boundBy: 0).tap()
        assert(app!.navigationBars["Record Activity"].staticTexts["Record Activity"].isHittable)
    }
    
    func testActivityHistoryNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Activity History").children(matching: .staticText).matching(identifier: "Activity History").element(boundBy: 0).tap()
        assert(app!.navigationBars["Activity History"].staticTexts["Activity History"].isHittable)
    }
    
    func testAchievementNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Achievements").children(matching: .staticText).matching(identifier: "Achievements").element(boundBy: 0).tap()
        assert(app!.navigationBars["Achievements"].staticTexts["Achievements"].isHittable)
    }
    
    func testTrailMapNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Trail Map").children(matching: .staticText).matching(identifier: "Trail Map").element(boundBy: 0).tap()
        assert(app!.navigationBars["Trail Map"].staticTexts["Trail Map"].isHittable)
    }
    
    func testAccountStatisticsNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Account Statistics").children(matching: .staticText).matching(identifier: "Account Statistics").element(boundBy: 0).tap()
        assert(app!.navigationBars["Account Statistics"].staticTexts["Account Statistics"].isHittable)
    }
    
    func testAccountDetailsNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"Account Details").children(matching: .staticText).matching(identifier: "Account Details").element(boundBy: 0).tap()
        assert(app!.navigationBars["Account Details"].staticTexts["Account Details"].isHittable)
    }
    
    func testAboutNavigation() {
        app!.navigationBars["Record Activity"].buttons["Menu"].tap()
        app!.tables.cells.containing(.staticText, identifier:"About").children(matching: .staticText).matching(identifier: "About").element(boundBy: 0).tap()
        assert(app!.navigationBars["About"].staticTexts["About"].isHittable)
        
    }
}
