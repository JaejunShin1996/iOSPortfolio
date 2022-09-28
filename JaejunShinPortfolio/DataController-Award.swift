//
//  DataController-Award.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 16/9/2022.
//

import CoreData
import Foundation

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
            // returns true if they added a certain number of items
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            // returns true if they completed a certain number of items
        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "chat":
            return UserDefaults.standard.integer(forKey: "chatCount") >= award.value
            // a unknown award; this should not be allowed
        default:
            // fatalError("Unknown award criterion \(award.criterion).")
            return false
        }
    }
}
