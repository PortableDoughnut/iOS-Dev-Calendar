//
//  DayView.RangeSelector.swift of CalendarView Demo
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import MijickCalendarView

extension MijickDayView { struct RangeSelector: DayView {
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MijickCalendarView.MDateRange?>?
}}
extension MijickDayView.RangeSelector {
    func createDayLabel() -> AnyView {
        Text(getStringFromDay(format: "d"))
            .font(.semiBold(15))
            .foregroundStyle(isSelected() ? .backgroundPrimary : .onBackgroundPrimary)
            .strikethrough(isPast())
            .opacity(isPast() ? 0.7 : 1)
            .erased()
    }
}

// MARK: - On Selection Logic
extension MijickDayView.RangeSelector {
    func onSelection() { if !isPast() {
        selectedRange?.wrappedValue?.addToRange(date)
    }}
}
