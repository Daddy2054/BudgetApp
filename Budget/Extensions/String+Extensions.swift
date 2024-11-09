//
//  String+Extensions.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import Foundation
extension String {
    var isEmptyOrWhitespace: Bool
    {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
