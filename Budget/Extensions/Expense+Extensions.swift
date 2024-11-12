//
//  Expense+Extensions.swift
//  Budget
//
//  Created by Jean on 11/11/24.
//

import Foundation
import CoreData

extension Expense {
    
    var total: Double {
        amount * Double(quantity)
    }
}
