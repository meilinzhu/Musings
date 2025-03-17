//
//  EntrySort.swift
//  musings
//
//  Sorting data for display
//  Sorting by date and source

//  Created by Meilin Zhu on 3/6/23.
//

import Foundation


struct EntrySort: Hashable, Identifiable {

  let id: Int
  let name: String
    
  let descriptors: [SortDescriptor<Entry>]
  let section: KeyPath<Entry, String>

  static let sorts: [EntrySort] = [
    EntrySort(
      id: 0,
      name: "Date | Descending",
      descriptors: [SortDescriptor(\Entry.date, order: .reverse)],
      section: \Entry.entryDate),
    EntrySort(
      id: 1,
      name: "Date | Ascending",
      descriptors: [ SortDescriptor(\Entry.date, order: .forward)],
      section: \Entry.entryDate),
    EntrySort(
      id: 1,
      name: "Source | Descending",
      descriptors: [SortDescriptor(\Entry.date, order: .reverse)],
      section: \Entry.source),
    EntrySort(
      id: 1,
      name: "Source | Ascending",
      descriptors: [SortDescriptor(\Entry.date, order: .forward)],
      section: \Entry.source)
  ]


  static var `default`: EntrySort { sorts[0] }
}
