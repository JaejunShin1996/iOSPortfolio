//
//  PerformanceTests.swift
//  JaejunShinPortfolioTests
//
//  Created by Jaejun Shin on 1/9/2022.
//

import XCTest
@testable import JaejunShinPortfolio

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformacne() throws {
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "You can change the number of the count")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }

    }
}
