//
//  BudgetApp.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import SwiftUI

@main
struct BudgetApp: App {
    
    let provider: CoreDataProvider
    let tagsSeeder: TagsSeeder
    
    init() {
        provider = CoreDataProvider()
        tagsSeeder = TagsSeeder(context: provider.context)
        
    }
    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
                .onAppear{
                    let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                    if !hasSeededData {
                        let commonTags = ["Food", "Dining", "Travel", "Entertainment", "Shopping", "Health", "Utilities", "Transportation", "Other"]
                        do {
                            try tagsSeeder.seed( commonTags)
                            UserDefaults.standard.setValue(true, forKey: "hasSeedData")
                        } catch {
                            print("Error seeding tags: \(error)")
                        }
                                 }
                    
                }
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
