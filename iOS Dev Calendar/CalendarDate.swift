//
//  CalendarDate.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//

import Foundation

struct CalendarDate {
    let date: Date
    let label: String
    let topic: String
    let outline: String?
    let homework: String?
    let instructor: String?

    init(date: Date, label: String, topic: String = "", outline: String? = nil, homework: String? = nil, instructor: String? = nil) {
        self.date = date
        self.label = label
        self.topic = topic
        self.outline = outline
        self.homework = homework
        self.instructor = instructor
    }
}
