//
//  BudgetListScreen.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("Budgets will be here")
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
    }
}
