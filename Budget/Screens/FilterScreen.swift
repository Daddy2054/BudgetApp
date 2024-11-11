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
    
    private enum SortOptions: CaseIterable, Identifiable {
        case title
        case date
        case amount
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .title: return "Title"
            case .date: return "Date"
            case .amount: return "Amount"
            }
        }
        
        var key: String {
            switch self {
            case .title: return "title"
            case .date: return "dateCreated"
            case .amount: return "amount"
            }
        }

    }
    
    private func filterTags() {
        if selectedTags.isEmpty {
            return
        }
        let selectedTagNames = selectedTags.map{$0.name}
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByPrice() {
        guard let startPrice = startPrice, let endPrice = endPrice else {
            return
        }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value:startPrice), NSNumber(value:  endPrice))
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByTitle() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[c] %@", title)
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByDate() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate
                                        , endDate as NSDate)
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
                    .onChange(of: selectedTags, filterTags)
            }
            Section("Filter by Price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search"){
                    filterByPrice()
                }
            }
            Section("Filter by Title") {
                TextField("Title", text: $title)
            Button("Search"){
                filterByTitle()
            }
            }
            
            Section("Filter by Date") {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                DatePicker("End date", selection: $endDate, displayedComponents: .date)
            Button("Search"){
                filterByDate()
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
                    filteredExpenses = expenses.map {$0}
                    selectedTags=[]
                }
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Filter")}
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}
