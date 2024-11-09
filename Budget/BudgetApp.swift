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
            ContentView()
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
