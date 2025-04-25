//
//  CalendarContainerView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarContainerView: View {
    // these come from UIKit
    @Binding var selectedDate: Date?
    @Binding var showAllDates: Bool
    let availableDates: [CalendarDate]
    
    // internal state
    @State private var selectedMonth: Date = .now
    private let events: [Date: [Event]] = [:]
    
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
    
    // initializer to wire up the bindings
    init(
        selectedDate: Binding<Date?>,
        availableDates: [CalendarDate],
        showAllDates: Binding<Bool>
    ) {
        self._selectedDate = selectedDate
        self.availableDates = availableDates
        self._showAllDates = showAllDates
    }
}

#Preview {
    CalendarContainerView(
        selectedDate: .constant(.now),
        availableDates: DataRepository.shared.calendarEntries.map {
            CalendarDate(date: $0.date, label: $0.item)
        },    showAllDates: .constant(true)
    )
}
