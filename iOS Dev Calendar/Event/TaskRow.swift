//
//  EventRow.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI

struct TaskRow: View {
    let entry: CalendarDate

    var body: some View {
        HStack(spacing: 10) {
            // you can pick a color based on the topic or leave it static for now
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.accentColor)
                .frame(width: 6, height: 20)

            VStack(alignment: .leading, spacing: 4) {
                // Show the topic as the “title”
                Text(entry.topic)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                // Use the label (e.g. "9:00-10:00") as the subtitle
                Text(entry.label)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
}
