//
//  JaejunShinPortfolioUITests.swift
//  JaejunShinPortfolioUITests
//
//  Created by Jaejun Shin on 1/9/2022.
//

import XCTest

class JaejunShinPortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tab buttons.")
    }

    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no projects initially.")

        for tapCount in 1...5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) projects.")
        }
    }

    func testInsertingItemIntoProject() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no items initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project.")

        app.buttons["Add Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 1 project and 1 item.")
    }

    func testEditingProjectsUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no items initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project.")

        app.buttons["Edit Project"].tap()

        app.textFields["Project name"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.staticTexts["New Project 2"].exists, "There should be New Project 2")
    }

    func testEditingItemsUpdatesCorrectly() {
        // Goes to open project and add a project and an item before the test.
        testInsertingItemIntoProject()

        app.buttons["New Item"].tap()
        app.textFields["Item name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["New Item 2"].exists, "There should be New Item 2")
    }

    func testAllAwardsLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            XCTAssertTrue(app.alerts["Locked"].exists, "The alert should show Locked")
            app.buttons["OK"].tap()
        }
    }

    func testOpenCloseProjectsMovesToEachTab() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no items initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project.")

        app.buttons["Edit Project"].tap()

        app.buttons["Close this Project"].tap()

        app.buttons["Closed"].tap()

        XCTAssertTrue(app.staticTexts["New Project"].exists, "There should be New Project")
    }

    func testUnlockingAwardsAlert() {
        // Goes to open project and add a project and an item before the test.
        testInsertingItemIntoProject()
        app.buttons["Awards"].tap()

        var count = 0

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            if count == 0 {
                count += 1
                XCTAssertFalse(app.alerts["Locked"].exists, "The alert should show unlocked something")
                app.buttons["OK"].tap()
            } else {
                XCTAssertTrue(app.alerts["Locked"].exists, "The alert should show Locked")
                app.buttons["OK"].tap()
            }
        }
    }

    func testSwipeToDeleteItems() {
        // Goes to open project and add a project and an item before the test.
        testInsertingItemIntoProject()

        app.buttons["New Item"].swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertEqual(app.tables.cells.count, 1, "Cells count should be 1 which is one project.")
    }
}
