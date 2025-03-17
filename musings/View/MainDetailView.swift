//
//  MainDetailView.swift
//  musings
//
//  This view shows details of an entry
//  User can also edit and delete entry from here
//  All attributes of an entry is displayed here (quote, musings, source, mood, date)
//  Editing an entry takes the user to AddMannualView
//  Deleting an entry prompts an alert for confirmation, once confirmed, entry is deleted
//  and user is taken back to MainListView

//  Created by Meilin Zhu on 3/4/23.
//

import SwiftUI

struct MainDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var entry: Entry
    @State var confirmDelete = false
    @State var setReminder = false
    @State var editMode = false
    
    var body: some View {
        // If user wants to edit, we pass the contents of the current entry to AddManualView
        if editMode{
            AddMannualView(quoteIn: entry.quote, moodIn: entry.mood, musingIn: entry.musing, sourceIn: entry.source, dateIn: entry.date)
        }else{
            VStack{
                Form{
                    Section("At the Time"){
                        HStack{
                            Text("\(entry.mood)")
                                .font(.system(size: 26))
                                .padding(10)
                            Text("\(entry.date)")
                            
                        }
                    }
                    Section("Source"){
                        HStack{
                            if entry.source .isEmpty {
                                Text("No source provided yet")
                            }else{
                                Text("\(entry.source)")
                            }
                        }
                    }
                
                
                
                Section("quote"){
                    Text("\(entry.quote)")
                        .padding(.bottom, 30)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                Section("musings"){
                    Text("\(entry.musing)")
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                }.padding(.bottom, 50)
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    // Share Entry
                    ShareLink(item: entry.quote, message: Text("Thought you might find this interesting")) {
                        Label("", systemImage:  "square.and.arrow.up")
                    }
                    
                    // Set Reminder
                    Button {
                        setReminder = true
                        let content = UNMutableNotificationContent()
                        content.title = "Musings"
                        content.subtitle = "Remember to finish your thoughts!"
                        content.sound = UNNotificationSound.default
                        
                        // for demo purpose, notification is set to show in five seconds
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request)
                    } label:{
                        Image(systemName: "alarm")
                    } .alert("You'll be reminded in 2 hours", isPresented: $setReminder) {
                        Button("OK", role: .cancel) { }
                    }
                    // Edit Entry
                    Button {
                        editMode = true
                    } label:{
                        Image(systemName: "pencil")
                    }
                    
                    // Delete Entry
                    Button {
                        confirmDelete = true
                    } label: {
                        Image(systemName: "trash.circle")
                    }.alert(isPresented: $confirmDelete) { () -> Alert in
                        let confirm = Alert.Button.default(Text("Confirm")) {
                            deletEntry(entry: entry)
                        }
                        return Alert(title: Text("Confirm"), message: Text("Are you sure you want to delete this entry?"), primaryButton: confirm, secondaryButton: .destructive(Text("Cancel")))
                    }
                }
            }
        }
    }
    func deletEntry(entry: Entry){
        viewContext.delete(entry)
       // try? viewContext.save()
        dismiss()
    }
}


struct MainDetailView_Previews: PreviewProvider {
    static func getEntry() -> Entry {
      let entry = Entry(context: DataManager(inMemory: true).persistentContainer.viewContext)
        entry.mood = "😀"
        entry.quote = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mattis ullamcorper tortor, nec finibus sapien imperdiet non. Duis tristique eros eget ex consectetur laoreet."
        entry.date = Date()
        entry.musing = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mattis ullamcorper tortor, nec finibus sapien imperdiet non. Duis tristique eros eget ex consectetur laoreet."
        entry.source = "life"
      return entry
    }
    static var previews: some View {
        MainDetailView(entry: getEntry())
    }
}
