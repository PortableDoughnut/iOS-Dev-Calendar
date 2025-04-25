//
//  CalendarGridView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarGridView: View {
    @Binding var selectedDate: Date?
    @Binding var selectedMonth: Date
    
    let availableDates: [CalendarDate]
    let buildDayView: (
        Date,
        Bool,
        Binding<Date?>?,
        Binding<MDateRange?>?
    ) -> DV.ColoredCircle
    
    var body: some View {
        MCalendarView(selectedDate: $selectedDate, selectedRange: nil) { config in
            config
                .monthLabel(ML.Uppercased.init)
                .monthsTopPadding(20)
                .monthsBottomPadding(10)
                .daysHorizontalSpacing(1)
                .daysVerticalSpacing(3)
                .dayView(buildDayView)
        }
        .scrollDisabled(false)
    }
}

// MARK: - Previews
struct CalendarGridView_Previews: PreviewProvider {
    @State private static var selectedDate: Date? = nil
    @State private static var selectedMonth: Date = Date()
    
    static var previews: some View {
        CalendarGridView(
            selectedDate: $selectedDate,
            selectedMonth: $selectedMonth,
            availableDates: DataRepository.shared.calendarEntries.map {
                CalendarDate(date: $0.date, label: $0.label)
            },      buildDayView: { date, isSelected, _, _ in
                DV.ColoredCircle(
                    date: date,
                    color: isSelected ? Color("AccentColor") : nil,
                    isCurrentMonth: true,
                    selectedDate: nil,
                    selectedRange: nil
                )
            }
        )
        .padding()
    }
}
