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

    // 1) Grab your CalendarDate models straight out of the repo
    private let availableDates: [CalendarDateModel] = DataRepository.shared.calendarDates

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
        // 2) Pass the same array into EventsView when a date is tapped
        .sheet(item: $selectedDate) { date in
            TaskView(date: date, entries: availableDates)
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
