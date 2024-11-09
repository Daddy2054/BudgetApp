//
//  AddBudgetScreen.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    @State private var title: String = ""
    @State private var limit: Double?
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && limit != nil && Double(limit!) > 0
    }
    var body: some View {
        Form {
            Text("New Budget")
                .font(.title)
                .font(.headline)
            
            TextField("Title", text: $title)
                .presentationDetents([.medium])
            TextField("Limit", value: $limit, format: .number)
                .keyboardType(.numberPad)
            Button {
                
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
        }
        .presentationDetents([.fraction(0.5), .medium])
    }
}

#Preview {
    AddBudgetScreen()
}
