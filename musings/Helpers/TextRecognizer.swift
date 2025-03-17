//
//  TextRecognizer.swift
//  musings
//
//  To perform text recognition, we are making request to APIs from Vision framework
// 
//  Created by Meilin Zhu on 3/6/23.
//


import SwiftUI
import UIKit
import Vision

struct TextRecognition {
    
    var scannedImages: [UIImage]
    @ObservedObject var scandata: ScanData
    @ObservedObject var scan: Scan
    var didFinishRecognition: () -> Void
    
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    let scanData = ScanData()
                    try requestHandler.perform([getTextRecognitionRequest(with: scanData)])
                    DispatchQueue.main.async {
                        scan.text = scanData.text
                        print("Text grabbed -->", scan.text)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            DispatchQueue.main.async {
                               didFinishRecognition()
                           }
            }
        }
    }
    
    
    private func getTextRecognitionRequest(with scanData: ScanData) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                scanData.text += recognizedText.string
                scanData.text += "\n"
        
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}
