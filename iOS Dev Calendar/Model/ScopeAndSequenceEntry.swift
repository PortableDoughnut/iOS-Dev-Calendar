//
//  ScopeAndSequenceEntry.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct ScopeAndSequenceEntry: Codable, Equatable {
    let dayID: String
    let color: String
    let topic: String
    let readingDue: String
    let homeworkDue: String
    let objectives: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case dayID, color, topic, readingDue, homeworkDue, objectives
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dayID = try container.decode(String.self, forKey: .dayID)
        color = try container.decode(String.self, forKey: .color)
        topic = try container.decode(String.self, forKey: .topic)
        readingDue = try container.decode(String.self, forKey: .readingDue)
        homeworkDue = try container.decode(String.self, forKey: .homeworkDue)
        objectives = try container.decode(String.self, forKey: .objectives)
        
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
