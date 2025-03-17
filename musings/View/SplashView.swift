//
//  SplashView.swift
//  musings
//
//  Splash page when launches
//  Animation help from
//https://stackoverflow.com/questions/64317185/swiftui-how-to-animate-transition-between-two-images-using-a-delay
// https://stackoverflow.com/questions/64654677/swiftui-change-images-on-a-timer-with-animation
//  Created by Meilin Zhu on 3/7/23.
//

import SwiftUI


struct SplashView: View {
  
    @AppStorage("splashShown") // UserDefaults
    var splashShown: Bool = false

    @State private var toMain = false;
    
    var body: some View {
        if toMain{
            ContentView()
        }else{
            VStack{
                    VStack{
                        Image("mred")
                            .resizable()
                            .frame(width: 100, height: 70)
                        Text("Musings")
                            .font(Font.custom("Palatino-Bold", size: 48.0))
                            .kerning(1)
                            .foregroundColor(mColors.st)
                        Text("developed by meilin")
                    }.foregroundColor(mColors.st)
                        .padding(.bottom, 100)
                    
                    VStack(alignment:.leading){
                        
                        HStack{
                            Text("📸")
                                .padding(.trailing)
                            Text("Capture")
                        }.padding(.top)
                        
                        HStack{
                            Text("🧐")
                                .padding(.trailing)
                            Text("Muse")
                        }.padding(.top)
                        HStack{
                            Text("💬")
                                .padding(.trailing)
                            Text("Share")
                        }.padding(.top)
                        
                    }.padding(.bottom, 100)
                        .frame(height: 120)
                        .foregroundColor(mColors.st)
                        .font(.title2)
            }.onAppear(perform: {
                UserDefaults.standard.splashShown = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.toMain = true
                    }
                }
            })
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
