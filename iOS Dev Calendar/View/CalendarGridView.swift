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
                .firstWeekday(.sunday)
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
