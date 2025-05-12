//
//  ReviewTopicEntry.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct ReviewTopicEntry: Codable, Equatable {
    let dayID: String
    let reviewTopic: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case dayID, reviewTopic
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dayID = try container.decode(String.self, forKey: .dayID)
        reviewTopic = try container.decode(String.self, forKey: .reviewTopic)
        
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
