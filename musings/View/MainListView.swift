//
//  MainListView.swift
//  musings

//  This view fetches the saved entries and returns them in list format
//  This view is made of multiple MainRowViews and navigates to MainDetailView which shows
//  More details about each entry

//  Created by Meilin Zhu on 3/4/23.
//

import SwiftUI

struct MainListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var addViewShown = false
    
    // Sorting entries if they are available
    @SectionedFetchRequest(
      sectionIdentifier: EntrySort.default.section,
      sortDescriptors: EntrySort.default.descriptors,
      animation: .default)
    
    // fetching from Core Data
    private var entry: SectionedFetchResults<String, Entry >
    @State private var selectedSort = EntrySort.default
    @State private var searchTerm = ""
    
    // customizing nav title font
    init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Palatino-Bold", size: 35)!]
        }
    var body: some View {
        NavigationView {
            List { // for each item in database
                ForEach(entry) { section in
                  Section(header: Text(section.id)) {
                    ForEach(section) { entry in
                      NavigationLink {
                          MainDetailView(entry: entry)
                      } label: {
                          MainRowView(entry: entry)
                      }
                    }
                  }
                }
            }
            .navigationTitle("Musings")
            .toolbar {
                // 1
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    SortView(
                        sortEntry: $selectedSort,
                        sorts: EntrySort.sorts)
                    // 3
                    .onChange(of: selectedSort) { _ in
                        let request = entry
                        request.sortDescriptors = selectedSort.descriptors
                        request.sectionIdentifier = selectedSort.section
                    }
                }
            }
        }
    }
            
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
