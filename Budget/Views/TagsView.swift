//
//  TagsView.swift
//  Budget
//
//  Created by Jean on 10/11/24.
//

import SwiftUI

struct TagsView: View {
    
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @Binding
    var selectedTag: Set<Tag>
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack{
                
                ForEach(tags) { tag in
                    Text(tag.name ?? "")
                        .padding(10)
                        .background(selectedTag.contains(tag) ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0,style: .continuous))
                        .onTapGesture {
                            if selectedTag.contains(tag) {
                                selectedTag.remove(tag)
                            }else {
                                selectedTag.insert(tag)
                            }
                        }
                }
            }.foregroundStyle(.white)
        }
    
    }
}

struct TagsViewContainerView: View {
    
    @State var selectedTag: Set<Tag> = []
    var  body: some View {
        TagsView(selectedTag: $selectedTag)
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
        
    }
}
#Preview {
    TagsViewContainerView()
}
