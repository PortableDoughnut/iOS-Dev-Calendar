//
//  CodeChallengeEntry.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct CodeChallengeEntry: Codable, Equatable {
    let dayID: String
    let fileName: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case dayID, fileName
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dayID = try container.decode(String.self, forKey: .dayID)
        fileName = try container.decode(String.self, forKey: .fileName)
        
        // Convert dayID to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dayID) {
            self.date = date
        } else {
            self.date = Date()
        }
    }
}
