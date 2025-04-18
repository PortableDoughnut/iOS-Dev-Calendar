//
//  CustomDayView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//

import SwiftUI
import MijickCalendarView

struct CustomDayView: DayView {
  let date: Date
  let isCurrentMonth: Bool
  let selectedDate: Binding<Date?>?
  let selectedRange: Binding<MDateRange?>?
  let availableDates: [CalendarDate]

  private let calendar = Calendar.current

  var isAvailable: Bool {
    let found = availableDates.first { calendar.isDate($0.date, inSameDayAs: date) }
    if found != nil {
      print("🎯 Found available date: \(date)") // Debug print
    }
    return found != nil
  }

  var dayType: DayType {
    if let calendarDate = availableDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
      let type = DayType.from(calendarDate.label)
      print("🎨 Day: \(calendarDate.label), Type: \(type), Color: \(type.color)") // Debug print
      return type
    }
    return .other
  }

  func createContent() -> AnyView {
    let currentDayType = dayType
    let currentCalendarDate = availableDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) })

    return HStack {
      VStack(spacing: 2) {
        Text(date.formatted(.dateTime.day()))
          .foregroundColor(determineTextColor())
          .fontWeight(isAvailable ? .bold : .regular)

        if let calendarDate = currentCalendarDate {
          Text(calendarDate.label)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(currentDayType.color)
            .minimumScaleFactor(0.5)

          if !calendarDate.topic.isEmpty {
            Text(calendarDate.topic)
              .font(.system(size: 8))
              .foregroundColor(currentDayType.color.opacity(0.8))
              .lineLimit(1)
              .minimumScaleFactor(0.5)
          }
        }
      }
    }
    .frame(height: 45)
    .padding(4)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(determineBackgroundColor())
    )
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(isSelected() ? currentDayType.color : Color.clear, lineWidth: 2)
    )
    .erased()
  }

  private func determineTextColor() -> Color {
    if !isCurrentMonth {
      return .gray
    }
    if isAvailable {
      return dayType.color
    }
    return .secondary
  }

  private func determineBackgroundColor() -> Color {
    if !isAvailable {
      return .clear
    }

    // Make background more visible for all types
    return dayType.color.opacity(0.2)
  }
}

#if DEBUG
struct CustomDayView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 15) {
      // Preview all types of days
      ForEach([
        "SF1", "TP1", "ND1", "ST1",
        "TT1", "FA1", "PC1", "GC1",
        "HOLIDAY"
      ], id: \.self) { label in
        CustomDayView(
          date: Date(),
          isCurrentMonth: true,
          selectedDate: .constant(nil),
          selectedRange: .constant(nil),
          availableDates: [CalendarDate(
            date: Date(),
            label: label,
            topic: "Sample Topic",
            outline: nil,
            homework: nil,
            instructor: nil
          )]
        )
      }
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
#endif

//import SwiftUI
//import MijickCalendarView
//
//struct CustomDayView: DayView {
//  let date: Date
//  let isCurrentMonth: Bool
//  let selectedDate: Binding<Date?>?
//  let selectedRange: Binding<MDateRange?>?
//  let availableDates: [CalendarDate]
//
//  private let calendar = Calendar.current
//
//  var isAvailable: Bool {
//    availableDates.contains { calendar.isDate($0.date, inSameDayAs: date) }
//  }
//
//  var dayType: DayType {
//    if let calendarDate = availableDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//      let type = DayType.from(calendarDate.label)
//      return type
//    }
//    return .other
//  }
//
//  private var calendarDateForCurrentDay: CalendarDate? {
//    availableDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
//  }
//
//  func createContent() -> AnyView {
//    let currentDayType = dayType
//    let currentCalendarDate = calendarDateForCurrentDay
//
//    return HStack {
//      VStack(spacing: 2) {
//        Text(date.formatted(.dateTime.day()))
//          .foregroundColor(isCurrentMonth ? (isAvailable ? currentDayType.color : .secondary) : .gray)
//          .fontWeight(isAvailable ? .bold : .regular)
//
//        if let calendarDate = currentCalendarDate {
//          Text(calendarDate.label)
//            .font(.system(size: 10, weight: .medium))
//            .foregroundColor(currentDayType.color)
//            .minimumScaleFactor(0.5)
//
//          // Only show topic if it exists and there's space
//          if !calendarDate.topic.isEmpty {
//            Text(calendarDate.topic)
//              .font(.system(size: 8))
//              .foregroundColor(currentDayType.color.opacity(0.8))
//              .lineLimit(1)
//              .minimumScaleFactor(0.5)
//          }
//        }
//      }
//    }
//    .frame(height: 50)
//    .padding(4)
//    .background(
//      RoundedRectangle(cornerRadius: 8)
//        .fill(isAvailable ? currentDayType.color.opacity(0.15) : Color.clear)
//    )
//    .overlay(
//      RoundedRectangle(cornerRadius: 8)
//        .stroke(isSelected() ? currentDayType.color : Color.clear, lineWidth: 2)
//    )
//    .erased()
//  }
//}
//
//#if DEBUG
//struct CustomDayView_Previews: PreviewProvider {
//  static var previews: some View {
//    VStack(spacing: 15) {
//      ForEach(["SF1", "TP1", "ND1", "ST1", "TT1", "FA1", "PC1", "GC1"], id: \.self) { label in
//        CustomDayView(
//          date: Date(),
//          isCurrentMonth: true,
//          selectedDate: .constant(nil),
//          selectedRange: .constant(nil),
//          availableDates: [CalendarDate(
//            date: Date(),
//            label: label,
//            topic: "Sample Topic",
//            outline: "Sample Outline",
//            homework: "Sample Homework",
//            instructor: "Sample Instructor"
//          )]
//        )
//      }
//    }
//    .previewLayout(.sizeThatFits)
//    .padding()
//  }
//}
//#endif
