//
//  Locale+Extensions.swift
//  Budget
//
//  Created by Jean on 10/11/24.
//

import Foundation

extension Locale {
    
    static var currencyCode: String {
        return Locale.current.currency?.identifier ?? "USD"
    }
}
