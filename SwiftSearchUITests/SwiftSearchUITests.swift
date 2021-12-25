//
//  SwiftSearchUITests.swift
//  SwiftSearchUITests
//
//  Created by Godwin A on 04/12/21.
//

import XCTest

class SwiftSearchUITests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws {}

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
