//
//  BudgetListScreen.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import SwiftUI

struct BudgetListScreen: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(budgets) { budget in
                BudgetCellView(budget: budget)
            }
        }.navigationTitle("Budget App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            } .sheet(isPresented: $isPresented, content: {
                AddBudgetScreen()
            } )  }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
        
    }            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}


