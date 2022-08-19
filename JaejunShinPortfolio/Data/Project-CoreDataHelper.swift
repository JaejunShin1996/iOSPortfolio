//
//  Project-CoreDataHelper.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 11/8/2022.
//

import Foundation


extension Project {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
    
    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted { first, second in
            if first.completion == false {
                if second.completion == true {
                    return true
                }
            } else if first.completion == true {
                if second.completion == false {
                    return false
                }
            }
            
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }
        
        let completedItems = originalItems.filter(\.completion)
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.creationDate = Date()
        project.closed = true
        
        return project
    }
    
    func projectItems(using sortOrder: Item.SortOrders) -> [Item] {
        switch sortOrder {
        case .optimised:
            return projectItemsDefaultSorted
        case .creationDate:
            return projectItems.sorted(by: \Item.itemCreationDate)
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        }
    }
}
