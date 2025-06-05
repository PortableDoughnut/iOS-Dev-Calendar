//
//  CalendarContainerView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import SwiftUI
import MijickCalendarView

struct IdentifiableDate: Identifiable, Equatable {
    let date: Date
    var id: TimeInterval { date.timeIntervalSinceReferenceDate }
}

struct CalendarContainerView: View {
    // these come from UIKit
    @Binding var selectedDate: Date?
    @Binding var showAllDates: Bool

    // your real JSON-backed dates
    let availableDates: [CalendarEntryModel]

    // NEW: Make this a StateObject to persist across view updates
    @StateObject private var viewModel = ViewModel()
    
    // internal state
    @State private var selectedMonth: Date = .now
    
    @State var showingListView = false

    var body: some View {
        VStack {
            HStack {
                Button {
                    // Refresh data from GitHub page
                } label: {
                    Image(systemName: "arrow.clockwise")
                }

                Spacer()
                
                Text("Calendar")
                    .font(.title)
                
                Spacer()
                
                Button(showingListView ? "Grid" : "List") {
                    showingListView.toggle()
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .padding()
            
            if !showingListView {
                VStack {
                    CalendarGridView(
                        selectedDate: Binding(
                            get: { selectedDate },
                            set: { newDate in
                                selectedDate = newDate
                                if let date = newDate {
                                    print("🎯 Selected date: \(date)")
                                    viewModel.showSheet(for: date)
                                }
                            }
                        ),
                        selectedMonth: $selectedMonth,
                        availableDates: availableDates,
                        buildDayView: buildDayView
                    )
                    .padding(.horizontal, 24)
                    .onChange(of: selectedDate) { oldValue, newValue in
                        print("🔵 CalendarGridView selectedDate changed from: \(String(describing: oldValue)) to: \(String(describing: newValue))")
                    }
                    
                    Spacer()
                }
                // PRESENT THE SHEET RELIABLY
                .sheet(item: $viewModel.selectedModalDate) { idDate in
                    TaskView(date: idDate.date, entries: DataRepository.shared.calendarEntries)
                        .presentationDetents([.height(300), .large])
                        .onDisappear {
                            viewModel.selectedModalDate = nil
                        }
                }
            } else {
                CalendarListView()
            }
        
        }
    }

    private func buildDayView(
        _ date: Date,
        _ isCurrentMonth: Bool,
        selectedDate: Binding<Date?>?,
        range: Binding<MDateRange?>?
    ) -> MijickDayView.ColoredCircle {
        MijickDayView.ColoredCircle(
            date: date,
            color: CalendarHelpers.color(for: date, available: availableDates),
            isCurrentMonth: isCurrentMonth,
            selectedDate: selectedDate,
            selectedRange: nil,
            availableDates: availableDates
        )
    }
    // initializer to wire up the bindings
    init(
        selectedDate: Binding<Date?>,
        availableDates: [CalendarEntryModel],
        showAllDates: Binding<Bool>
    ) {
        self._selectedDate = selectedDate
        self.availableDates = availableDates
        self._showAllDates = showAllDates
    }
}

// MARK: - ViewModel
extension CalendarContainerView {
    class ViewModel: ObservableObject {
        @Published var selectedModalDate: IdentifiableDate?
        
        func showSheet(for date: Date) {
            selectedModalDate = IdentifiableDate(date: date)
        }
    }
}

#Preview {
    CalendarContainerView(
        selectedDate: .constant(Date()),
        availableDates: DataRepository.shared.calendarEntries,
        showAllDates: .constant(true)
    )
}
