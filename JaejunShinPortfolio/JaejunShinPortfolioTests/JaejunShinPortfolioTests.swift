//
//  JaejunShinPortfolioTests.swift
//  JaejunShinPortfolioTests
//
//  Created by Jaejun Shin on 29/8/2022.
//

import CoreData
import XCTest
@testable import JaejunShinPortfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
