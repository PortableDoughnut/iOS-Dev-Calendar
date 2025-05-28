//
//  View++.swift of CalendarView Demo
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Frame
extension View {
    func frame(_ size: CGFloat) -> some View { frame(width: size, height: size, alignment: .center) }
}

// MARK: - Active Flag
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}

extension View {
    func inExpandingRectangle(color: Color? = nil) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color ?? Color.clear)
            self
        }
    }
}
