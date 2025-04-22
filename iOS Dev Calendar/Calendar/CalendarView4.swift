//
//  CalendarView4.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/18/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarView4: View {
  @State private var selectedDate: Date? = .now
  @State private var selectedMonth: Date = .now
  private let availableDates: [CalendarDate] = CSVDateLoader.loadDatesFromCSV()
  private let events: [Date: [Event]] = .init()
  private let monthFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "LLLL yyyy"
    return f
  }()

  var body: some View {
    VStack(spacing: 10) {

      // Custom month header
      HStack {
        Text(monthFormatter.string(from: selectedMonth).uppercased())
          .font(.title.bold())
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.horizontal, 24)
          .id(selectedMonth)
          .transition(.opacity.combined(with: .slide))
          .animation(.bouncy(duration: 0.3), value: selectedMonth)
      }

      // Custom weekdays strip
      WeekdayHeader()
        .padding(.horizontal, 24)
        .padding(.top, 4)

      // Calendar grid with built-in header & month label hidden
      MCalendarView(selectedDate: $selectedDate, selectedRange: nil) { config in
        config
          .weekdaysView(EmptyWeekdaysView.init)
          .monthLabel { date in EmptyMonthLabel(month: date) }          .onMonthChange { newMonth in
            withAnimation(.easeInOut(duration: 0.3)) {
              selectedMonth = newMonth
            }
          }
          .monthsTopPadding(20)
          .monthsBottomPadding(10)
          .daysHorizontalSpacing(1)
          .daysVerticalSpacing(3)
          .dayView(buildDayView)
      }
      .frame(height: 325)
      // enough to show one month
      .scrollDisabled(false)
      // lock the built-in ScrollView
      .padding(.horizontal, 24)

      Divider()
        .frame(height: 4)
        .overlay(Color.gray)

      Spacer().frame(height: 24)

      EventsView(selectedDate: $selectedDate, events: events)
        .padding(.horizontal, 20)

      Spacer()
    }
  }

  //TODO: Make calendar vertically scrollable through all actual calendar months but have custom month label update depending on month visible or add arrows if needed. 

  private func buildDayView(
    _ date: Date,
    _ isCurrentMonth: Bool,
    selectedDate: Binding<Date?>?,
    range: Binding<MDateRange?>?
  ) -> DV.ColoredCircle {
    .init(date: date,
          color: getColorForDate(date),
          isCurrentMonth: isCurrentMonth,
          selectedDate: selectedDate,
          selectedRange: nil)
  }

  private func getColorForDate(_ date: Date) -> Color? {
    let strippedDate = Calendar.current.startOfDay(for: date)
    guard let calendarDate = availableDates.first(where: {
      Calendar.current.isDate(Calendar.current.startOfDay(for: $0.date), inSameDayAs: strippedDate)
    }) else {
      return nil
    }
    return DayType.from(calendarDate.label).color
  }
}

// MARK: - Event Model
extension CalendarView4 {
  struct Event: Equatable, Hashable {
    let name: String
    let range: String
    let color: Color
  }
}

// MARK: - Events View
extension CalendarView4 {
  struct EventsView: View {
    @Binding var selectedDate: Date?
    let events: [Date: [Event]]

    var body: some View {
      VStack(alignment: .leading, spacing: 16) {
        Text(title)
          .font(.system(size: 20, weight: .bold))
          .frame(maxWidth: .infinity, alignment: .leading)

        if let todaysEvents = events[selectedDate] {
          VStack(spacing: 20) {
            ForEach(todaysEvents, id: \.self) { event in
              HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 3)
                  .fill(event.color)
                  .frame(width: 6, height: 20)

                VStack(alignment: .leading, spacing: 4) {
                  Text(event.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                  Text(event.range)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                  
                }
              }
            }
          }
        }
      }
//      .background(Color.gray)
    }

    private var title: String {
      guard let selectedDate else { return "" }
      if Calendar.current.isDateInToday(selectedDate) {
        return "TODAY"
      } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: selectedDate).uppercased()
      }
    }
  }
}

// MARK: - Helpers
fileprivate extension [Date: [CalendarView4.Event]] {
  init() {
    let events1: [CalendarView4.Event] = [
      .init(name: "Waffle Party", range: "06:10 - 07:15", color: .green),
      .init(name: "Praise Kier", range: "12:00 - 14:15", color: .red)
    ]
    let events2: [CalendarView4.Event] = [
      .init(name: "Standup meeting with Ryan", range: "08:00 - 08:15", color: .orange)
    ]
    let events3: [CalendarView4.Event] = [
      .init(name: "Submit capstone to the app store", range: "15:00 - 16:00", color: .red)
    ]
    self = [
      Date.now: events1,
      Date.now.addingTimeInterval(2 * 86400): events2,
      Date.now.addingTimeInterval(3 * 86400): events3
    ]
  }

  subscript(_ key: Date?) -> [CalendarView4.Event]? {
    guard let key else { return nil }
    return self.first(where: { Calendar.current.isDate($0.key, inSameDayAs: key) })?.value
  }
}

// Helper types to hide built‑in views and hide the built‑in weekdays strip
struct EmptyWeekdaysView: WeekdaysView {
  func createContent() -> AnyView {
    AnyView(EmptyView())
  }
}

struct EmptyMonthLabel: MonthLabel {
  var month: Date
  func createContent() -> AnyView {
    AnyView(EmptyView())
  }
}

// MARK: - Preview
struct WeekdayHeader: View {
  private let symbols: [String]
  init() {
    let s = Calendar.current.veryShortWeekdaySymbols
    let first = Calendar.current.firstWeekday - 1
    symbols = Array(s[first...] + s[..<first])
  }
  var body: some View {
    HStack(spacing: 1) {
      ForEach(symbols, id: \.self) { day in
        Text(day)
          .font(.system(size: 12, weight: .bold))
          .frame(maxWidth: .infinity)
      }
    }
  }
}

#Preview {
  CalendarView4()
}
