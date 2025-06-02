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
    var color: Color {
        let dayIDPrefix = scopeAndSequenceEntry.dayID.prefix(2)
        let dayType = DayType(rawValue: String(dayIDPrefix))
        return dayType?.color ?? .gray
    }
    
    @State var showDetails = false
    
    var body: some View {
        VStack {
            Grid(verticalSpacing: 0) {
                GridRow {
                    VStack {
                        Text("\(date?.formatted(Date.FormatStyle().weekday(.abbreviated)) ?? "")")
                        Text("\(date?.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year(.twoDigits)) ?? "")")
                        Text("\(scopeAndSequenceEntry.dayID)")
                    }
                    .monospaced()
                    .padding()
                    .background {
                        color
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(scopeAndSequenceEntry.topic)
                        .font(.thin(14))
                        .padding(.trailing)
                    
                    Spacer()
                                        
                    Image(systemName: "chevron.right.circle")
                        .rotationEffect(showDetails ? Angle(degrees: 90) : Angle(degrees: 0))
                }
                
                if showDetails {
                    GridRow {
                        Text("Reading Due")
                        Text(scopeAndSequenceEntry.readingDue.isEmpty ? "None" : scopeAndSequenceEntry.readingDue)
                    }
                    .padding(.vertical)
                    .font(.caption)
                    GridRow {
                        Text("Assignments Due")
                        Text(scopeAndSequenceEntry.assignmentsDue.isEmpty ? "None" : scopeAndSequenceEntry.assignmentsDue)
                    }
                    .padding(.bottom)
                    .font(.caption)
                    
                }
            }
            
            if showDetails {
                Button("Go to Lesson Details") {
                    
                }
                .padding(.bottom)
            }
        }
        .padding(.trailing)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showDetails.toggle()
        }
    }
}

#Preview {
    CalendarListView()
}
