//
//  ExpenseCellView.swift
//  Budget
//
//  Created by Jean on 10/11/24.
//

import SwiftUI

struct ExpenseCellView: View {
    
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.title ?? "")
            Spacer()
            Text(expense.amount, format: .currency(code:Locale.currencyCode))
            
        }
    }
}
struct ExpenseCellViewContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View { ExpenseCellView (expense: expenses[0])}
}

#Preview {
    ExpenseCellViewContainer()
    .environment(\.managedObjectContext, CoreDataProvider.preview.context)}
