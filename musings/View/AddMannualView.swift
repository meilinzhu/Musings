//
//  AddMannualView.swift
//  musings
//
//  This view is where users can input entries
//  Whether the text is manually typed or scanned, users are taken here to complete the entry
//  Only quote is an required input, everything else is optional
//  Date is always the current date and time unless user changes it
//  User also has the option to get a reminder in 2 or 12 hours
//
//  Created by Meilin Zhu on 3/5/23.
//

import SwiftUI
import CoreData
import UserNotifications

// help on notifications
// https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications
enum NotificationAction: String {
    case dimiss
    case reminder
}

enum NotificationCategory: String {
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
}

struct AddMannualView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    
    @StateObject var scan = Scan()
    @ObservedObject var scanData = ScanData()
    
    var entryId: NSManagedObjectID?
    let viewModel = AddViewModel()
    
    // parameters passed from other views
    var quoteIn: String
    var moodIn: String
    var musingIn: String
    var sourceIn: String
    var dateIn: Date
    
    @State private var mood = ""
    @State private var quote = ""
    @State private var musing = ""
    @State private var source = ""
    @State private var date = Date()
    @State private var sendAlert = false
    @State private var isEditMode = false
    @State var getReminder = false
    @State var entryError = false
    
    var body: some View {
        VStack {
            Form{
                Section("Currently"){
                    HStack (alignment: .center){
                        EmojiTextField(text: $mood, placeholder: "🫥")
                            .padding(.leading, 30)
                            .frame(height: 50)
                        Image(systemName: "pencil")
                            .frame(width: 6, height: 6)
                        
                        DatePicker("", selection: $date)
                            .padding(.leading, 50)
                    }.padding(.top)
                }
                Section("Quote"){
                    TextField("", text: $quote, axis: .vertical)
                        .lineLimit(150)
                        .textSelection(.enabled)
                        .frame(height: 120)
                }
                Section("Musing"){
                    TextField("", text: $musing, axis: .vertical)
                        .lineLimit(150)
                        .textSelection(.enabled)
                        .frame(height: 120)
                }
                Section("Source"){
                    TextField("Book, article, magazine...", text: $source)
                        .textSelection(.enabled)
                }
            }.padding(.bottom, 50)
           
        } // Add entry saves the contents of form to Core Data
        .navigationBarTitle("Add Entry")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if quote.isEmpty {
                        entryError = quote.isEmpty
                    }else{
                        let values = EntryValues(
                            mood: mood,
                            quote: quote,
                            musing: musing,
                            source: source,
                            date: date
                        )
                        
                        viewModel.saveEntry(
                            entryId: entryId,
                            with: values,
                            in: viewContext)
                      presentation.wrappedValue.dismiss()
                        
                    }
                }
            }
        }.onAppear(){ // setting the variables if they are being passed in
            quote = self.quoteIn
            mood = self.moodIn
            source = self.sourceIn
            musing = self.musingIn
            date = self.dateIn
        }
    }
}


struct AddMannualView_Previews: PreviewProvider {

    static var previews: some View {
        AddMannualView(quoteIn: "", moodIn: "", musingIn: "", sourceIn: "", dateIn: Date())
    }
}
