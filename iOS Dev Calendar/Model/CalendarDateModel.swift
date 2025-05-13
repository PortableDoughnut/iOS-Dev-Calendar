//
//  CalendarDate.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//

import Foundation

struct CalendarDateModel: Decodable, Hashable {
    let date: Date
    let label: String
    let topic: String
    let outline: String?
    let homework: String?
    let instructor: String?

    enum CodingKeys: String, CodingKey {
        case date
        case label = "item"
        case topic
        case outline
        case homework
        case instructor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        label = try container.decode(String.self, forKey: .label)
        
        topic = try container.decodeIfPresent(String.self, forKey: .topic) ?? "" 
        
        outline = try container.decodeIfPresent(String.self, forKey: .outline)
        homework = try container.decodeIfPresent(String.self, forKey: .homework)
        instructor = try container.decodeIfPresent(String.self, forKey: .instructor)
    }
    
    init(date: Date, label: String, topic: String = "", outline: String? = nil, homework: String? = nil, instructor: String? = nil) {
        self.date = date
        self.label = label
        self.topic = topic
        self.outline = outline
        self.homework = homework
        self.instructor = instructor
    }
}
