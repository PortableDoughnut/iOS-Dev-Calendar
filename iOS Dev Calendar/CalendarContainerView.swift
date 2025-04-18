//
//  CalendarContainerView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarContainerView: View {
  @Binding var selectedDate: Date?
  let availableDates: [CalendarDate]
  @Binding var showAllDates: Bool

  var body: some View {
    MCalendarView(
      selectedDate: $selectedDate,
      selectedRange: .constant(nil)
    ) { config in
      config
        .startMonth(Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)) ?? Date())
        .endMonth(Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31)) ?? Date())
        .firstWeekday(.sunday)
        .monthsSpacing(24)
        .daysVerticalSpacing(8)
        .daysHorizontalSpacing(4)
        .monthsViewBackground(Color(.systemBackground))
        .dayView { date, isCurrentMonth, selectedDateBinding, selectedRangeBinding in
          CustomDayView(
            date: date,
            isCurrentMonth: isCurrentMonth,
            selectedDate: selectedDateBinding,
            selectedRange: selectedRangeBinding,
            availableDates: availableDates
          )
        }
    }
  }
}

#if DEBUG
struct CalendarContainerView_Previews: PreviewProvider {
  static var previews: some View {
    let previewDates = CSVDateLoader.loadDatesFromCSV()
    return CalendarContainerView(
      selectedDate: .constant(nil),
      availableDates: previewDates,
      showAllDates: .constant(true)
    )
  }
}
#endif
