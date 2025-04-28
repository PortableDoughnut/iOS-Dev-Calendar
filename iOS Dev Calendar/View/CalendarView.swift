//
//  CalendarView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/18/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarView: View {
    @State private var selectedDate: Date? = .now
    @State private var selectedMonth: Date = .now
    private let availableDates: [CalendarDate] = DataRepository.shared.calendarEntries.map {
        CalendarDate(date: $0.date, label: $0.item)
    }
    private let events: [Date: [Event]] = .init()
    
    var body: some View {
        VStack {
            CalendarGridView(
                selectedDate: $selectedDate,
                selectedMonth: $selectedMonth,
                availableDates: availableDates,
                buildDayView: buildDayView
            )
            .padding(.horizontal, 24)
            Spacer()
        }
        .sheet(item: $selectedDate) { date in
            EventsView(date: date, events: events)
                .presentationDetents([.height(300), .large])
        }
    }
    
    private func buildDayView(
        _ date: Date,
        _ isCurrentMonth: Bool,
        selectedDate: Binding<Date?>?,
        range: Binding<MDateRange?>?
    ) -> DV.ColoredCircle {
        DV.ColoredCircle(
            date: date,
            color: CalendarHelpers.color(for: date, available: availableDates),
            isCurrentMonth: isCurrentMonth,
            selectedDate: selectedDate,
            selectedRange: nil,
            availableDates: availableDates
        )
    }
}

#Preview {
    CalendarView()
}
