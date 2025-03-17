//
//  ScannerView.swift
//  musings
//
// We are using SwiftUI framework to access UIViewControllerRepresentable protocol
// and VisionKit for VNDocumentCameraViewController
//
//  Created by Meilin Zhu on 3/6/23.
//

import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void
    
    // creating a new VNDocumentCameraViewController instance
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerView
        
        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        
        // MARK: - VNDocumentCameraViewControllerDelegate
        // Called when images are available
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedPages = [UIImage]()
            
            for i in 0..<scan.pageCount {
                scannedPages.append(scan.imageOfPage(at: i))
            }
            
            scannerView.didFinishScanning(.success(scannedPages))
        }
        
        //  Called when  user cancels the scan
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancelScanning()
        }
        
        //  Called when an error has occurred
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScanning(.failure(error))
        }
    }
    
}


