//
//  Budget+Extensions.swift
//  Budget
//
//  Created by Jean on 09/11/24.
//

import Foundation
import CoreData

extension Budget {
    static func exists(context: NSManagedObjectContext,title: String) -> Bool {
        
        
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error fetching budgets: \(error)")
            return false
        }
    
    }
}
