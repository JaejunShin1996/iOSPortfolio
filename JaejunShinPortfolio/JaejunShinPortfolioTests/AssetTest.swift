//
//  AssetTest.swift
//  JaejunShinPortfolioTests
//
//  Created by Jaejun Shin on 29/8/2022.
//

import XCTest
@testable import JaejunShinPortfolio

class AssetTests: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }
}
