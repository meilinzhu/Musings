//
//  ContentView.swift
//  musings
//
//  This is the main page that the user is taken to once the splash page is completed
//  The user will see entries from MainListView and tabs to navigate to other pages
//
//  Created by Meilin Zhu on 3/7/23.
//

import SwiftUI
import UIKit


struct ContentView: View {
    
    @State var showAlert = false
    @AppStorage("appLaunches") private var appLaunches = 0
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        TabView {
            MainListView()
                .tabItem {
                    Label("Quotes", systemImage: "list.bullet")
                    Text("Quote")
                }
            MainAddView()
                .tabItem {
                    Label("Add", systemImage: "plus.square")
                    Text("Add")
                }
        }
        .alert("Enjoying this app?", isPresented: $showAlert, actions: {
            Button("Not now", role: .cancel, action: {})
            Button("Sure", action: {if let url = URL(string: "https://www.apple.com/app-store/") {
                openURL(url)
                }})
            }, message: {
                Text("Give us a ⭐️?")
            })
        .accentColor(mColors.red)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                appLaunches += 1
            }
        }
        .onAppear(perform: show)
      
    }

    func show(){
        print("App Launches: ", appLaunches)
        if appLaunches == 3{
            showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
