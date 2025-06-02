//
//  CalendarEntry.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct CalendarEntryModel: Codable {
    let date: Date
    let item: String
}

extension CalendarEntryModel {
    var scope: ScopeAndSequenceEntry? {
        DataRepository.shared.scopeAndSequence.first { $0.dayID == self.item }
    }
}

extension CalendarEntryModel: Identifiable {
    var id: UUID {
        UUID()
    }
}
