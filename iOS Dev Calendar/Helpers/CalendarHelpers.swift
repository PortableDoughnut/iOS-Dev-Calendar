//
//  CalendarHelpers.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI

enum CalendarHelpers {
    /// Formatter for month header strings like "April 2025"
    static let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f
    }()
    
    /// Returns color for a date based on available calendar data
    static func color(for date: Date, available: [CalendarEntryModel]) -> Color? {
        let stripped = Calendar.current.startOfDay(for: date)
        guard let match = available.first(where: {
            Calendar.current.isDate(Calendar.current.startOfDay(for: $0.date), inSameDayAs: stripped)
        }) else { return nil }
        return DayType.from(match.item).color
    }
    
    /// Title for events sheet, e.g. "TODAY" or "MONDAY, 21 APRIL"
    static func formattedTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "TODAY"
        } else {
            let fmt = DateFormatter()
            fmt.dateFormat = "EEEE, d MMMM"
            return fmt.string(from: date).uppercased()
        }
    }
    
    /// Very short weekday symbols starting from calendar.firstWeekday
    static func weekdaySymbols() -> [String] {
        let s = Calendar.current.veryShortWeekdaySymbols
        let first = Calendar.current.firstWeekday - 1
        return Array(s[first...] + s[..<first])
    }
}
