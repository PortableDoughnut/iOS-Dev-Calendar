//
//  Button.Icon.swift of CalendarView Demo
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension MijickButton { struct Icon: View {
    let imageName: String
    let colour: Color
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .frame(24)
                .foregroundStyle(colour)
        }
    }
}}

// MARK: - Preview
#Preview {
    MijickButton.Icon(imageName: "back", colour: .accent, action: {})
}
