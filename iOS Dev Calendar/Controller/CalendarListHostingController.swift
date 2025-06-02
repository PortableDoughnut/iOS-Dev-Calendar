//
//  CalendarListHostingController.swift
//  iOS Dev Calendar
//
//  Created by Jane Madsen on 5/22/25.
//

import Foundation
import UIKit
import SwiftUI

class CalendarListHostingController: UIHostingController<CalendarListView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: CalendarListView())
    }
}

struct CalendarListView: View {
    private var calendarEntries = DataRepository.shared.calendarEntries.filter { !$0.item.isEmpty }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(calendarEntries) { entry in
                    ScopeAndSequenceEntryView(calendarEntry: entry)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    CalendarListView()
}
