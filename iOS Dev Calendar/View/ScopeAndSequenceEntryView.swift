//
//  ScopeAndSequenceEntryView.swift
//  iOS Dev Calendar
//
//  Created by Jane Madsen on 5/28/25.
//

import Foundation
import SwiftUI

struct ScopeAndSequenceEntryView: View {
    let calendarEntry: CalendarEntryModel
    var scopeAndSequenceEntry: ScopeAndSequenceEntry? {
        calendarEntry.scope
    }

    var color: Color {
        let dayIDPrefix = calendarEntry.item.prefix(2)
        let dayType = DayType(rawValue: String(dayIDPrefix))
        return dayType?.color ?? .gray
    }
    
    @State var showDetails: Bool = false
    
    var body: some View {
        VStack {
            Grid(verticalSpacing: 0) {
                GridRow {
                    VStack {
                        Text("\(calendarEntry.date.formatted(Date.FormatStyle().weekday(.abbreviated)))")
                        Text("\(calendarEntry.date.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year(.twoDigits)))")
                        Text("\(calendarEntry.item)")
                    }
                    .monospaced()
                    .padding()
                    .background {
                        color
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(scopeAndSequenceEntry?.topic ?? "")
                        .font(.thin(14))
                        .padding(.trailing)
                    
                    Spacer()
                                        
                    if scopeAndSequenceEntry != nil {
                        Image(systemName: "chevron.right.circle")
                            .rotationEffect(showDetails ? Angle(degrees: 90) : Angle(degrees: 0))
                    }
                }
                
                if showDetails, let scopeAndSequenceEntry {
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
            
            if showDetails, let scopeAndSequenceEntry {
                Button("Go to Lesson Details") {
                    print(scopeAndSequenceEntry.objectives)
                }
                .padding(.bottom)
            }
        }
        .padding(.trailing)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showDetails.toggle()
            print("I, \(calendarEntry.item), was tapped. Show details is now \(showDetails)")
        }
    }
}

#Preview {
    CalendarListView()
}
