//
//  FilterScreen.swift
//  Budget
//
//  Created by Jean on 11/11/24.
//

import SwiftUI

struct FilterScreen: View {
    
    @Environment(\.managedObjectContext)  private var context
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var filteredExpenses: [Expense] = []
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var selectedSortOption: SortOptions? = nil
    @State private var selectedSortDirection: SortDirection? = .ascending
    @State private var selectedFilterOption: FilterOption? = nil
    
    private enum FilterOption: Equatable, Identifiable {
        case none
        case byTags(Set<Tag>)
        case byDateRange(startDate:Date, endDate: Date)
        case byPriceRange(minPrice: Double, maxPrice: Double)
        case byTitle(String)
        
        
        var id: String {
            switch self {
            case .none: return "none"
            case .byTags: return "tags"
            case .byDateRange: return "dateRange"
            case .byPriceRange: return "priceRange"
            case .byTitle: return "title"
            }
        }
        
        
    }
    
    private enum SortDirection: CaseIterable, Identifiable {
        case ascending
        case descending
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .ascending: return "Ascending"
            case .descending: return "Descending"
            }
        }
    }
    
    private enum SortOptions: String, CaseIterable, Identifiable {
        case title = "title"
        case date = "dateCreated"
        case amount = "amount"
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .title: return "Title"
            case .date: return "Date"
            case .amount: return "Amount"
            }
        }
        
        var key: String {
            rawValue
                }
        
    }
    
    private func performFilter() {
        guard let selectedFilterOption = selectedFilterOption else {
            return
        }
        
        let request = Expense.fetchRequest()
        switch selectedFilterOption {
        case .byPriceRange(let minPrice, let maxPrice):
            request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value:minPrice), NSNumber(value:  maxPrice))
        case .byTitle(let title):
            request.predicate = NSPredicate(format: "title CONTAINS[c] %@", title)
        case .byDateRange(let startDate, let endDate):
            request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        case .none:
            request.predicate = NSPredicate(value: true)
        case .byTags(let tags):
            let tagNames = tags.map { $0.name}
            request.predicate = NSPredicate(format: "ANY tags.name IN %@", tagNames)
        }
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func performSort() {
        guard let sortOption = selectedSortOption else {
            return
        }
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirection == .ascending ? true : false)]
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        List{
            
            Section("Sort") {
                Picker("Sort Options", selection: $selectedSortOption
                ) {
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases) { sortOption in
                        Text(sortOption.title).tag(Optional(sortOption))
                    }
                }
                
                Picker("Sort Direction", selection: $selectedSortDirection) {
                    ForEach(SortDirection.allCases) { sortDirection in
                        Text(sortDirection.title).tag(Optional(sortDirection))
                    }
                }
                Button("Sort"){
                    performSort()
                }
                .buttonStyle(.borderless)
            }
            
            Section("Filter by Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, {
                        selectedFilterOption = .byTags(selectedTags)
                    })
            }
            Section("Filter by Price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search"){
                    guard let startPrice, let endPrice else { return }
                    selectedFilterOption = .byPriceRange(minPrice: startPrice, maxPrice: endPrice)
                }
            }
            Section("Filter by Title") {
                TextField("Title", text: $title)
                Button("Search"){
                    selectedFilterOption = .byTitle(title)
                }
            }
            
            Section("Filter by Date") {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                DatePicker("End date", selection: $endDate, displayedComponents: .date)
                Button("Search"){
                    selectedFilterOption = .byDateRange(startDate: startDate, endDate: endDate)
                }
            }
            
            Section("Expenses") {
                ForEach(filteredExpenses) { expense in
                    ExpenseCellView(expense: expense)
                }
            }
            
            HStack {
                Spacer()
                
                Button("Show All"){
                    selectedFilterOption = FilterOption.none
                }
                Spacer()
            }
        }
        .onChange(of: selectedFilterOption, performFilter)
        .padding()
        .navigationTitle("Filter")}
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}
