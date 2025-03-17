//
//  MainRowView.swift
//  musings
//
//  This view is constructing what each row displayed on MainListView looks like
//  For each entry we're showing the mood emoji, the date, and the source
//  Created by Meilin Zhu on 3/4/23.
//

import SwiftUI

struct MainRowView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var entry: Entry
    var body: some View {
        HStack{
            
            if entry.mood .isEmpty{
                Text("🫥")
                    .font(.system(size: 36))
                    .padding(10)
            }else{
                Text("\(entry.mood)")
                    .font(.system(size: 36))
                    .padding(10)
            }
            VStack(alignment: .leading){
                if entry.source .isEmpty{
                    Text("No Source Provided")
                        .italic()
                }else{
                    Text("\(entry.source)")
                        .bold()
                }
                Text(entry.date, style: .date)
            }.frame(height: 100)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct MainRowView_Previews: PreviewProvider {
    static func getEntry() -> Entry {
      let entry = Entry(context: DataManager(inMemory: true).persistentContainer.viewContext)
        entry.mood = "😀"
        entry.quote = "ganeonave"
        entry.date = Date()
        entry.musing = "gaergae"
        entry.source = "life"
      return entry
    }
    
    static var previews: some View {
        MainRowView(entry: getEntry())
    }
}
