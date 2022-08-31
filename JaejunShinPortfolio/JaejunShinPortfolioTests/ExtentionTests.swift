//
//  ExtentionTests.swift
//  JaejunShinPortfolioTests
//
//  Created by Jaejun Shin on 31/8/2022.
//

import SwiftUI
import XCTest
@testable import JaejunShinPortfolio

class ExtentionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let numbers = [4, 2, 1, 5, 3]
        let sortedNumbers = numbers.sorted(by: \.self)

        XCTAssertEqual(sortedNumbers, [1, 2, 3, 4, 5], "Numbers should be ascending.")
    }

    func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let arrayOfExamples = [example1, example2, example3]

        let sortedExamples = arrayOfExamples.sorted(by: \.value, using: >)

        XCTAssertEqual(sortedExamples, [example3, example2, example1], "Examples should be desceding.")
    }

    func testBundleDecodingAwards() {
        let allAwards = Bundle.main.decode(
            [Award].self,
            from: "Awards.json",
            dateDecodingStrategy: .deferredToDate,
            keyDecodingStrategy: .useDefaultKeys
        )

        XCTAssertFalse(allAwards.isEmpty, "All awards should be loaded.")
    }

    func testBundleDecodingString() {
        let bundle = Bundle(for: ExtentionTests.self)
        let decodedString = bundle.decode(
            String.self,
            from: "DecodableString.json"
        )

        XCTAssertEqual(
            decodedString,
            "I am going to keep hustling till I make it.",
            "Decoded string should be matched"
        )
    }

    func testBundleDecodingDictionary() {
        let bundle = Bundle(for: ExtentionTests.self)
        let decodedDictionary = bundle.decode([String: Int].self, from: "DecodableDictionary.json")

        XCTAssertEqual(decodedDictionary.count, 3, "Decoded Data should have 3 items inside")
        XCTAssertEqual(decodedDictionary["One"], 1, "First value of the array is 1")
    }

    func testBindingOnChange() {
        var exampleOnChange = false

        func exampleChangeToTrue() {
            exampleOnChange = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedValue = binding.onChange(exampleChangeToTrue)
        changedValue.wrappedValue = "Test"

        XCTAssertTrue(exampleOnChange, "The onChange() function was not run.")
    }
}
