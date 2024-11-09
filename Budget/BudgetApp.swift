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
    
    init() {
        provider = CoreDataProvider()
    }
    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
