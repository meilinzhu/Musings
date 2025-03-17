//
//  MainAddView.swift
//  musings
//
//  This view for user to chose how they would like to input their quote/information
//  Manual add takes user to AddMannualView
//  Scan brings up a sheet presentation with camera view where user scan the document
//  Once scan is complete, user is brought to AddMannualView to complete entry
//  Info alert is below scan option in case user is not able to use camera due to permission
//  issues
//
//  Created by Meilin Zhu on 3/4/23.
//

import SwiftUI
import UIKit

struct MainAddView: View {
    @StateObject var scan = Scan()
    @ObservedObject var scanData = ScanData()
    @State var showScanner = false
    @State var addViewActive = false
    @State var scanViewActive = false
    @State private var isRecognizing = false
    @State private var showAlert = false
  
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center){
                NavigationStack{
                    // If user choses to scan, a sheet view will display camera view
                    // user will be prompted to give permssion if they have not already
                    VStack{
                        
                        if isRecognizing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemIndigo)))
                                .padding(.bottom, 20)
                                
                        }
                            
                        Button {
                            addViewActive = true
                        } label: {
                            Label("Add Manually", systemImage: "keyboard")
                        }
                        .font(Font.custom("Palatino-Bold", size: 18.0))
                        .padding(20)
                        .frame(width: 250)
                        .foregroundColor(mColors.brown)
                        .background(mColors.yellow)
                        .cornerRadius(10)
                        .navigationDestination(isPresented: $addViewActive){
                            AddMannualView(quoteIn: "", moodIn: "", musingIn: "", sourceIn: "", dateIn: Date())
                        }
                        
                        Button {
                            self.showScanner = true
                            print("starting camera")
                            print("text --> ", scan.text)
                        } label: {
                            Label("Scan with Camera", systemImage: "doc.viewfinder")
                        }
                        .sheet(isPresented: $showScanner, content: { ScannerView { result in
                            switch result {
                            case .success(let scannedImages):
                                isRecognizing = true
                                TextRecognition(scannedImages: scannedImages,
                                                scandata: scanData,
                                                scan: scan){
                                    
                                    // Text recognition is finished, hide the progress indicator.
                                    isRecognizing = false
                                    scanViewActive = true
                                }.recognizeText()
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            
                            showScanner = false
                            
                            
                        } didCancelScanning: {
                            // Dismiss the scanner controller and the sheet
                            showScanner = false
                        }
                        })
                        .navigationDestination(isPresented: $scanViewActive){
                            if scan.text .isEmpty {
                                AddMannualView(quoteIn: "Sorry, could not scan text" , moodIn: "", musingIn: "", sourceIn: "", dateIn: Date())
                            }
                            else{
                                AddMannualView(quoteIn: "\(scan.text)", moodIn: "", musingIn: "", sourceIn: "", dateIn: Date())
                            }
                            
                        }
                        .font(Font.custom("Palatino-Bold", size: 18.0))
                        .padding(20)
                        .frame(width: 250)
                        .foregroundColor(mColors.brown)
                        .background(mColors.red)
                        .cornerRadius(10)
                        
                        Button {
                            showAlert = true
                        } label:{
                            Image(systemName: "questionmark.circle")
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("Info"), message: Text("You will need to grant permission to use 'Scan with Camera'. Please check your settings!"), dismissButton: .default(Text("Got it!")))
                        }.padding()
                        }
                    }
                }
                
            }
        }
    }


struct MainAddView_Previews: PreviewProvider {
    static var previews: some View {
        MainAddView()
    }
}
