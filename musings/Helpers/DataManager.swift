//
//  DataManager.swift
//  musings
//
//  Created by Meilin Zhu on 3/4/23.
//

import CoreData

struct DataManager {
  static let shared = DataManager()

  let persistentContainer: NSPersistentContainer

  init(inMemory: Bool = false) {
    persistentContainer = NSPersistentContainer(name: "Data")
    if inMemory,
      let storeDescription = persistentContainer.persistentStoreDescriptions.first {
      storeDescription.url = URL(fileURLWithPath: "/dev/null")
    }

    persistentContainer.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unable to configure Core Data Store: \(error), \(error.userInfo)")
      }
    }
  }

  static var preview: DataManager = {
    let result = DataManager(inMemory: true)
    let viewContext = result.persistentContainer.viewContext
    for entryCount in 0..<10 {
      let newEntry = Entry(context: viewContext)
        newEntry.quote = "Quote \(entryCount)"
        newEntry.musing = "Thought \(entryCount)"
        newEntry.date = Date()
        newEntry.source = "Book"
    }
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
}
