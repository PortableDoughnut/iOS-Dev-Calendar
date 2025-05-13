//
//  MonthLabel.Uppercased.swift of CalendarView Demo
//
//  Created by Alina Petrovska on 02.12.2023.
//    - Mail: alina.petrovskaya@mijick.com
//    - GitHub: https://github.com/Mijick
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import MijickCalendarView

extension MijickMonthLabel { struct Uppercased: MonthLabel {
    let month: Date
    
    func createContent() -> AnyView {
        HStack(spacing: 8) {
            createYearLabel()
            createMonthLabel()
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .erased()
    }
}}

private extension MijickMonthLabel.Uppercased {
    func createYearLabel() -> some View {
        Text(yearText)
            .font(.thin(26))
            .bold()
            .foregroundStyle(Color.grayAccent)
    }
    func createMonthLabel() -> some View {
        Text(monthText)
            .font(.bold(26))
            .foregroundStyle(Color.grayAccent)
    }
}

private extension MijickMonthLabel.Uppercased {
    var yearText: String { getString(format: "yyyy") }
    var monthText: String { getString(format: "MMMM").uppercased() }
}

