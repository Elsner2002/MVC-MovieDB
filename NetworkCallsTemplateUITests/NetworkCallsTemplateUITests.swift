//
//  NetworkCallsTemplateUITests.swift
//  NetworkCallsTemplateUITests
//
//  Created by Luciana Lemos on 26/03/24.
//

import XCTest
@testable import NetworkCallsTemplate

final class NetworkCallsTemplateUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    func testCellClickedSuccess() throws {
        let tablesQuery = app.tables
        let listTable = tablesQuery.children(matching: .cell)
        let row = 2
        let cell = listTable.element(boundBy: row)
        XCTAssertTrue(cell.exists)
    }
    
    func testCellClickedFailure() throws {
        let tablesQuery = app.tables
        let listTable = tablesQuery.children(matching: .cell)
        let row = 500
        
        let cell = listTable.element(boundBy: row)
        XCTAssertFalse(cell.exists)
    }
    
    func testTitleCell() throws {
        let tablesQuery = app.tables
        let listTable = tablesQuery.children(matching: .cell)
        let row = 0
        
        let cell = listTable.element(boundBy: row)
        XCTAssertTrue(cell.exists)
        
        cell.tap()
        
        let title = cell.staticTexts["Kung Fu Panda 4"]
        XCTAssertTrue(title.exists)
    }
    
//    func testOverview() throws {
//        let tablesQuery = app.tables
//        let listTable = tablesQuery.children(matching: .cell)
//        let row = 0
//
//        let cell = listTable.element(boundBy: row)
//        XCTAssertTrue(cell.exists)
//
//        cell.tap()
//
//        let small = cell.cells["smallMovieCell"]
//        XCTAssertTrue(small.exists)
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
