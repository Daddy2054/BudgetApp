//
//  EditExpenseScreen.swift
//  Budget
//
//  Created by Jean on 12/11/24.
//

import SwiftUI

struct EditExpenseScreen: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let expense: Expense
    @State private var expenseTitle: String = ""
    @State private var expenseAmount: Double?
    @State private var expenseQuantity: Int = 0
    @State private var expenseSelectedTags: Set<Tag> = []
    
    private func updateExpense() {
        expense.title = expenseTitle
        expense.amount = expenseAmount ?? 0.0
        expense.quantity = Int16(expenseQuantity)
        expense.tags = NSSet(array: Array(expenseSelectedTags))
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving expense: \(error)")
        }
    }
    
    var body: some View {
        Form{
            TextField("Title", text: $expenseTitle)
            TextField("Amount", value: $expenseAmount, format: .number)
            TextField("Quantity", value: $expenseQuantity, format: .number)
            TagsView(selectedTags: $expenseSelectedTags)
        }
        .onAppear (perform: {
            expenseTitle = expense.title ?? ""
            expenseAmount = expense.amount
            expenseQuantity = Int(expense.quantity)
            if let tags = expense.tags {
                
                expenseSelectedTags = Set(tags.compactMap { $0 as? Tag})
            }
        }
        )
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Update"){
                    updateExpense()
                }
            }
        })
        
        .navigationTitle(expense.title ?? "")    }
}

struct EditExpenseContaiinerView: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        NavigationStack {
            EditExpenseScreen(expense: expenses.first!)
        }
    }
}
#Preview {
    EditExpenseContaiinerView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
