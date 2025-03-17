//
//  SortView.swift
//  musings
//
//  This view handles sorting from MainListView
//
//  Created by Meilin Zhu on 3/9/23.
//

import SwiftUI

struct SortView: View {
    
    @Binding var sortEntry: EntrySort
    // Array to provide the list of sorting preferences the view
    let sorts: [EntrySort]
    
    // Depending on the sorting preference, it will sort according to the models in EntrySort
    var body: some View {
        Menu {
          Picker("Sort By", selection: $sortEntry) {
            ForEach(sorts, id: \.self) { sort in
              Text("\(sort.name)")
            }
          }
        } label: {
          Label(
            "Sort",
            systemImage: "line.horizontal.3.decrease.circle")
        }
        .pickerStyle(.inline)
      }
}

struct SortView_Previews: PreviewProvider {
    @State static var sort = EntrySort.default
    static var previews: some View {
        SortView( sortEntry: $sort,
                  sorts: EntrySort.sorts)
    }
}
