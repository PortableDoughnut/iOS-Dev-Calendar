//
//  DayView.ColoredCircle.swift of CalendarView Demo
//
//  Created by Alina Petrovska on 02.12.2023.
//    - Mail: alina.petrovskaya@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import MijickCalendarView
import Foundation

extension DV {
    struct ColoredCircle: DayView {
        var date: Date
        var color: Color?
        var isCurrentMonth: Bool
        var selectedDate: Binding<Date?>?
        var selectedRange: Binding<MDateRange?>?
        var availableDates: [CalendarDate]

        @Environment(\.colorScheme) private var colorScheme
    }
}

extension DV.ColoredCircle {
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
            .foregroundColor(getTextColor())
    }
  
    // Determine circle fill color based on unit prefix from JSON data
    private var unitColor: Color {
        print("🔶 unitColor: checking date \(date)")
        // Find the matching entry by date
        guard let entry = DataRepository.shared.calendarEntries.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) else {
            return .clear
        }
        // Extract the two‑letter prefix (e.g. "SF", "TP", etc.)
        let prefix = String(entry.label.prefix(2))
        print("  ↪️ prefix: \(prefix)")
        switch prefix {
        case "SF": print("  ↪️ prefix: \(prefix)"); return .blue
        case "TP": print("  ↪️ prefix: \(prefix)"); return .green
        case "ND": print("  ↪️ prefix: \(prefix)"); return .yellow
        case "ST": print("  ↪️ prefix: \(prefix)"); return .orange
        case "TT": print("  ↪️ prefix: \(prefix)"); return .red
        case "FA": print("  ↪️ prefix: \(prefix)"); return .pink
        case "PC": print("  ↪️ prefix: \(prefix)"); return .purple
        case "GC": print("  ↪️ prefix: \(prefix)"); return .mint
        case "HO": // Holiday
            print("  ↪️ prefix: \(prefix)")
            return .gray
        default:
            return .clear
        }
        return colorScheme == .dark ? .white : .black
    }
}

private extension DV.ColoredCircle {
    var unitColor: Color {
        guard let entry = availableDates.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) else {
            return .gray.opacity(0.2) // fallback for weekends/non-unit days
        }

        let prefix = String(entry.label.prefix(2)).uppercased()

        switch prefix {
        case "SF": return .blue
        case "TP": return .green
        case "ND": return .yellow
        case "ST": return .orange
        case "TT": return .red
        case "FA": return .pink
        case "PC": return .purple
        case "GC": return .mint
        case "HO": return .gray
        default: return .gray.opacity(0.2)
        }
    }
}
