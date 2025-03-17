//
//  LaunchView.swift
//  musings
//
//  Created by Meilin Zhu on 3/9/23.
//

import SwiftUI

extension UserDefaults {
    
    var splashShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "splashShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "splashShown")
        }
    }
    
}


struct LaunchView: View {
    @State private var isActive = false
    @State private var showSplash = false
    @State private var showContent = false
    @State private var images = ["mred", "myellow", "mbrown", "mpink"]
    @State private var index = 0
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        if showContent{
            ContentView()
        }
        else if showSplash{
            SplashView()
        }
        else {
            VStack {
                VStack{
                    if self.isActive {
                        Image("\(images[self.index])")
                            .resizable()
                            .frame(width: 200, height: 150)
                            .transition(AnyTransition.opacity.animation(.linear(duration: 1.5)))
                    }
                }.onReceive(timer) { _ in
                    print("splash count:", self.index)
                    self.index += 1
                    self.isActive.toggle()
                    if self.index > 4 { self.index = 0 }
                }
                .frame(height:150)
                
                Divider()
                    .frame(width: 200, height: 4)
                    .edgesIgnoringSafeArea(.horizontal)
                    .padding()
                Text("Musings")
                    .font(Font.custom("Palatino-Bold", size: 37.0))
                    .foregroundColor(mColors.st)
                    .padding(.bottom, 50)
                    .kerning(3)
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if UserDefaults.standard.splashShown {
                        withAnimation {
                            self.showContent = true
                        }
                    }
                    else{
                            withAnimation {
                                showSplash = true
                            }
                        }
                    }
                }
            }
        }

    }

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
