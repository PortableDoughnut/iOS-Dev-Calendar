//
//  EventsView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI
import Foundation

struct EventsView: View {
    let date: Date
    let events: [Date: [Event]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let todaysEvents = events[date] {
                VStack(spacing: 20) {
                    ForEach(todaysEvents, id: \.self) { event in
                        EventRow(event: event)
                    }
                }
            }
        }
    }
    
    private var title: String {
        CalendarHelpers.formattedTitle(for: date)
    }
}
