//
//  SearchViewUITests.swift
//  MealPrepCapstoneUITests
//
//  Created by Nate Schaffner on 7/14/24.
//

import Foundation
import XCTest

class SearchViewUITests: XCTestCase {
  func testOnboardingView() throws {
    let app = XCUIApplication()
    app.launchArguments += ["-hasRunBefore", "false"]
    app.launch()
    app.buttons["Continue"].tap()
  }

  func tapCoordinate(at xCoordinate: Double, and yCoordinate: Double, app: XCUIApplication) {
    let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
    let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
    coordinate.tap()
  }

  func testSearchView() throws {
    let app = XCUIApplication()
    app.launchArguments += ["-hasRunBefore", "true"]
    app.launch()
    app.tabBars.buttons["Search"].tap()
    app.searchFields["Type here to search"].tap()
    app.searchFields["Type here to search"].typeText("chicken")
    app.searchFields["Type here to search"].typeText("\n")
    tapCoordinate(at: 200, and: 200, app: app)
    app.buttons["Save"].tap()
    app.tabBars.buttons["Home"].tap()
    tapCoordinate(at: 200, and: 200, app: app)
    app.tabBars.buttons["Search"].tap()
    app.buttons["Delete"].tap()
  }
  func testSavedView() throws {
    let app = XCUIApplication()
    app.launchArguments += ["-hasRunBefore", "true"]
    app.launch()
    app.tabBars.buttons["Home"].tap()
    tapCoordinate(at: 200, and: 200, app: app)
  }
}
