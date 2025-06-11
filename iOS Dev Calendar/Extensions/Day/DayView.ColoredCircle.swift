//
//  DayView.ColoredCircle.swift of CalendarView Demo
//
//  Created by Alina Petrovska on 02.12.2023.
//    - Mail: alina.petrovskaya@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright 2023 Mijick. Licensed under MIT License.


import SwiftUI
import MijickCalendarView
import Foundation

extension MijickDayView {
    struct ColoredCircle: DayView {
        var date: Date
        var color: Color?
        var isCurrentMonth: Bool
        var selectedDate: Binding<Date?>?
        var selectedRange: Binding<MDateRange?>?
        var availableDates: [CalendarEntryModel]

        @Environment(\.colorScheme) private var colorScheme
    }
}

extension MijickDayView.ColoredCircle {
    func createDayLabel() -> AnyView {
        ZStack {
            createDayLabelBackground()
            createUnitBorder()
            createSelectionView()
            createDayLabelText()
        }
        .erased()
    }

    func createSelectionView() -> AnyView {
        Circle()
            .strokeBorder(Color("AccentColor"), lineWidth: 2)
            .transition(.asymmetric(
                insertion: .scale(scale: 0.5).combined(with: .opacity),
                removal: .opacity)
            )
            .active(if: isSelected())
            .erased()
    }

    private func createUnitBorder() -> some View {
        Circle()
            .strokeBorder(unitColor, lineWidth: 2)
            .padding(4)
    }

    private func createDayLabelBackground() -> some View {
        Circle()
            .fill(isSelected() ? Color("AccentColor") : unitColor)
            .padding(4)
    }

    private func createDayLabelText() -> some View {
        Text(getStringFromDay(format: "d"))
            .font(.regular(17))
//            .foregroundColor(getTextColor())
    }

    // Determine circle fill color based on unit prefix from JSON data
    private var unitColor: Color {
        // Find the matching entry by date
        guard let entry = DataRepository.shared.calendarEntries.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) else {
            return .clear
        }
        // Extract the two‑letter prefix (e.g. "SF", "TP", etc.)
        let prefix = String(entry.item.prefix(2))
        switch prefix {
        case "SF":
            return .blue
        case "TP":
            return .green
        case "ND":
            return .yellow
        case "ST":
            return .orange
        case "TT":
            return .red
        case "FA":
            return .pink
        case "PC":
            return .purple
        case "GC":
            return .mint
        case "HO": // Holiday
            return .gray
        default:
            return .clear
        }
    }
}
