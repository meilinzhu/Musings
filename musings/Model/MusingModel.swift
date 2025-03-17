//
//  MusingModel.swift
//  musings
//
//  Created by Meilin Zhu on 3/5/23.
//


import CoreData

@objc(Entry)
public class Entry: NSManagedObject{
    
    @objc var entryDate: String {
      return date.formatted(.dateTime.month(.wide).day().year())
    }
    @objc var entryDateDescending: String {
      return date.formatted(.dateTime.month(.wide).day().year()) + " "
    }
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Entry> {
      return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var mood: String
    @NSManaged public var quote: String
    @NSManaged public var source: String
    @NSManaged public var musing: String
    @NSManaged public var date: Date
    
}

extension Entry: Identifiable {}
