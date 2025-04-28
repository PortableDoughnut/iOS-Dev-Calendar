//
//  EventsView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI

struct TaskView: View {
    let date: Date
    let entries: [CalendarDate]

    private var todaysEntries: [CalendarDate] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(CalendarHelpers.formattedTitle(for: date))
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            if todaysEntries.isEmpty {
                Text("No items for today")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                VStack(spacing: 20) {
                    ForEach(todaysEntries, id: \.self) { entry in
                        TaskRow(entry: entry)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

//TODO: Add SwiftData or way to persist checking off assignments and tasks in the TaskView
