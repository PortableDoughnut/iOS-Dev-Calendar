//
//  DayView.Unit.swift of CalendarView Demo
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import MijickCalendarView

extension DV {
    struct Unit: DayView {
        let date: Date
        let isCurrentMonth: Bool
        let selectedDate: Binding<Date?>?
        let selectedRange: Binding<MijickCalendarView.MDateRange?>?
        let availableDates: [CalendarDateModel]
        
        private let calendar = Calendar.current
        
        // Finds the matching calendar entry for this day
        private var calendarDate: CalendarDateModel? {
            availableDates.first { calendar.isDate($0.date, inSameDayAs: date) }
        }
        
        // Returns the DayType enum based on label
        private var dayType: DayType {
            if let label = calendarDate?.label {
                return DayType.from(label)
            }
            return .other
        }
        
        private var isAvailable: Bool {
            calendarDate != nil
        }
    }
}

// MARK: - View Building
extension DV.Unit {
    func createContent() -> AnyView {
        ZStack {
            createSelectionView()
            createDayLabel()
        }
        .erased()
    }
    
    internal func createDayLabel() -> AnyView {
        VStack(spacing: 6) {
            Text(getStringFromDay(format: "d"))
                .font(.semiBold(15))
                .foregroundStyle(determineTextColor())
            
            if let label = calendarDate?.label {
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(dayType.color)
            }
            
            if let topic = calendarDate?.topic, !topic.isEmpty {
                Text(topic)
                    .font(.system(size: 8))
                    .foregroundStyle(dayType.color.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(determineBackgroundColor())
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .erased()
    }
    
    internal func createSelectionView() -> AnyView {
        RoundedRectangle(cornerRadius: 6)
            .stroke(isSelected() ? dayType.color : Color.clear, lineWidth: 2)
            .padding(1)
            .erased()
    }
}

// MARK: - Utility + Styling
private extension DV.Unit {
    func determineTextColor() -> Color {
        if !isCurrentMonth {
            return .gray
        }
        return isAvailable ? dayType.color : .secondary
    }
    
    func determineBackgroundColor() -> Color {
        isAvailable ? dayType.color.opacity(0.15) : .clear
    }
}

// MARK: - Selection
extension DV.Unit {
    func onSelection() {
        if isAvailable {
            selectedDate?.wrappedValue = date
        }
    }
}
