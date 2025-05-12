//
//  WordOfTheDay.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct WordOfTheDay: Codable, Equatable {
    let dayID: String
    let word: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case dayID, word
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dayID = try container.decode(String.self, forKey: .dayID)
        word = try container.decode(String.self, forKey: .word)
        
        // Convert dayID to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dayID) {
            self.date = date
            print("📅 Successfully decoded date for WordOfTheDay: \(date)")
        } else {
            print("⚠️ Failed to decode date for WordOfTheDay with dayID: \(dayID)")
            self.date = Date()
        }
    }
}
