//
//  AwardTests.swift
//  JaejunShinPortfolioTests
//
//  Created by Jaejun Shin on 30/8/2022.
//

import CoreData
import XCTest
@testable import JaejunShinPortfolio

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesNames() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should match its name")
        }
    }

    func testNewUserHasNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New user should not earned any awards.")
        }
    }

    func testAwardsByAddingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                _ = Item(context: managedObjectContext)
            }

            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, index + 1, "Adding \(value) should have \(index + 1) awards")

            dataController.deleteAll()
        }
    }

    func testAwardsByCompletingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                item.completed = true
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, index + 1, "Completing \(value) should have \(index + 1) awards")

            dataController.deleteAll()
        }
    }
}
