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
    
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context
        
        let entertainment = Budget(context: context)
        entertainment.title = "Entertainment"
        entertainment.limit = 500
        entertainment.dateCreated = Date()
        
        let groceries = Budget(context: context)
        groceries.title = "Groceries"
        groceries.limit = 200
        groceries.dateCreated = Date()
        
        let milk = Expense(context: context)
        milk.title = "Milk"
        milk.amount = 1.50
        milk.dateCreated = Date()
        
        let cookie = Expense(context: context)
        cookie.title = "Cookie"
        cookie.amount = 3.50
        cookie.dateCreated = Date()
        
        groceries.addToExpenses(milk)
        groceries.addToExpenses(cookie)
        
        // liist of expenses
        let foodItems = ["Pizza", "Burger", "Pasta", "Salad", "Soup", "Bread", "Coffee",  "Tea", "Chocolate", "Ice Cream", "Cake", "Donuts", "Pancakes", "Waffles"]
        for foodItem in foodItems {
            let expense = Expense(context: context)
            expense.title = foodItem
            expense.amount = Double.random(in: 1...100)
            expense.dateCreated = Date()
            expense.budget = groceries
        }
        // insert tags
        let commonTags = ["Food", "Dining", "Travel", "Entertainment", "Shopping", "Health", "Utilities", "Transportation", "Groceries","Other"]
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            if let tagName = tag.name,  ["Food", "Shopping"].contains(tagName)
            {
                cookie.addToTags(tag)
            }
            if let tagName = tag.name, ["Health"].contains(tagName) {
                milk.addToTags(tag)
            }
    
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        return provider
        
    }()
    
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
