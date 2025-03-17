//
//  Model.swift
//  musings
//
//  Created by Meilin Zhu on 3/4/23.
//

import Foundation


class ScanData: ObservableObject{
    @Published var text: String = ""
}

class Scan: ObservableObject{
    @Published var text: String = ""
}

//struct GoogleBooks: Codable {
//    let kind: String
//    let id: Int
//    let volumeInfo: VolumeInfo
//}
//
//struct VolumeInfo: Codable {
//    let title: String
//    let authors: String
//    let description: String
//    let imageUrl: String
//}

struct EntryValues{
    let quote: String
    let musing: String
    let source: String
    let date: Date
    let mood: String
    
    init(mood: String, quote:String, musing: String, source: String, date: Date) {
        self.mood = mood
        self.quote = quote
        self.musing = musing
        self.source = source
        self.date = date
    }
}
