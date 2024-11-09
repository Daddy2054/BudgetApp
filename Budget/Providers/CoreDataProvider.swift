//
//  CoreDataProvider.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import Foundation
import CoreData
class CoreDataProvider {
    var persistentContainer: NSPersistentContainer
    
    var context : NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetModel")
        if inMemory {
            let description = persistentContainer.persistentStoreDescriptions.first!
            description.url = URL(filePath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
}
