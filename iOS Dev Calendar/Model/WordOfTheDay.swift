//
//  WordOfTheDay.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct WordOfTheDay: Codable, Equatable {
    /// Put this back in if the word of the day starts using dayID
    /*
    let dayID: String
    let date: Date
    */
    let word: String
    
    enum CodingKeys: String, CodingKey {
        case word

        // Put this back in if the word of the day starts using dayID
        /*
        case dayID
        case date = "date"
        */
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        /// Put this back in if the word of the day starts using dayID
        // dayID = try container.decode(String.self, forKey: .dayID)
        word = try container.decode(String.self, forKey: .word)
        
        /// Put this back in if the word of the day starts using dayID
        /* let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dayID) {
            self.date = date
            print("📅 Successfully decoded date for WordOfTheDay: \(date)")
        } else {
            print("⚠️ Failed to decode date for WordOfTheDay with dayID: \(dayID)")
            self.date = Date()
        }
        */
    }
}
