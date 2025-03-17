//
//  musingsApp.swift
//  musings
//
//  Created by Meilin Zhu on 3/4/23.
//

import SwiftUI


@main
struct musingsApp: App {
    
    private var delegate: NotificationDelegate = NotificationDelegate()
    // we are asking user for permission to send alert at the start
   init() {
       let center = UNUserNotificationCenter.current()
       center.delegate = delegate
       center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
           if let error = error {
               print(error)
           }
       }
   }
       
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environment(\.managedObjectContext, DataManager.shared.persistentContainer.viewContext)
        }
    }

}
