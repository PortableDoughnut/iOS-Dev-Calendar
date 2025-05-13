//
//  Button.Rectangle.swift of CalendarView Demo
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension MijickButton { struct Rectangle: View {
    let imageName: String
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .frame(52)
                .foregroundStyle(.onBackgroundPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .background(.backgroundSecondary, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}}

// MARK: - Preview
#Preview {
    HStack(spacing: 16) {
        MijickButton.Rectangle(imageName: "calendar-1", action: {})
        MijickButton.Rectangle(imageName: "calendar-2", action: {})
    }
}
