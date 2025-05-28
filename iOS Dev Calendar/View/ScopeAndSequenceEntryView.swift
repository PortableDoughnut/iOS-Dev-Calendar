//
//  ScopeAndSequenceEntryView.swift
//  iOS Dev Calendar
//
//  Created by Jane Madsen on 5/28/25.
//

import Foundation
import SwiftUI

struct ScopeAndSequenceEntryView: View {
    let scopeAndSequenceEntry: ScopeAndSequenceEntry
    var date: Date? {
        DataRepository.shared.calendarEntries.first(where: { $0.label == scopeAndSequenceEntry.dayID })?.date
    }
        
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(" \(date?.formatted(Date.FormatStyle().weekday(.abbreviated)) ?? "") \(date?.formatted(date: .numeric, time: .omitted) ?? "") - LessonID: \(scopeAndSequenceEntry.dayID)")
                    .monospaced()
                
                Spacer()
            }
            
            HStack(alignment: .top) {
                VStack {
                    Text("Topic")
                    Text(scopeAndSequenceEntry.topic)
                        .padding()
                }
                VStack {
                    Text("Reading Due")
                    Text(scopeAndSequenceEntry.readingDue)
                        .padding()
                }
                VStack {
                    Text("Assignments Due")
                    Text(scopeAndSequenceEntry.assignmentsDue)
                        .padding()
                }
            }
            .font(.caption)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10).fill(.gray)
        }
    }
}

#Preview {
    ScopeAndSequenceEntryView(scopeAndSequenceEntry: DataRepository.shared.scopeAndSequence.first!)
}
