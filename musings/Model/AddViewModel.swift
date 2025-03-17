//
//  AddViewModel.swift
//  musings
//
//  ViewModel for saving and fetching data object
//
//  Created by Meilin Zhu on 3/6/23.
//

import CoreData

struct AddViewModel {
    
  func fetchEntry(for objectId: NSManagedObjectID, context: NSManagedObjectContext) -> Entry? {
    guard let entry = context.object(with: objectId) as? Entry else {
      return nil
    }

    return entry
  }

  func saveEntry(
    entryId: NSManagedObjectID?,
    with entryValues: EntryValues,
    in context: NSManagedObjectContext
  ) {
    let entry: Entry
    if let objectId = entryId,
      let fetchEntry = fetchEntry(for: objectId, context: context) {
      entry = fetchEntry
    } else {
      entry = Entry(context: context)
    }
      
      entry.quote = entryValues.quote
      entry.musing = entryValues.musing
      entry.mood = entryValues.mood
      entry.source = entryValues.source
      entry.date = entryValues.date
    do {
      try context.save()
        print("saving -->", "quote:", entry.quote, "mood: ", entry.mood, " date: ", entry.date, " musings ", entry.musing, " source ", entry.source)
    } catch {
      print("Save error: \(error)")
    }
  }
}
