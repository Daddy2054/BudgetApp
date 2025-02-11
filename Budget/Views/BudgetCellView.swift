//
//  SwiftUIView.swift
//  Budget
//
//  Created by Jean on 10/11/24.
//

import SwiftUI

struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}
