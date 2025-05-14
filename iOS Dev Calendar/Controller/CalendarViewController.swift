//
//  CalendarViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.


import UIKit
import SwiftUI
import MijickCalendarView

class CalendarViewController: UIViewController {
    private var selectedDate: Date? = nil
    private var availableDates: [CalendarDateModel] = DataRepository.shared.calendarEntries.map {
        CalendarDateModel(date: $0.date, label: $0.label)
    }
    private var showAllDates: Bool = true
    private var currentFilter: DayType? = nil
    private var filteredDates: [CalendarDateModel] = []
    private var calendarView: CalendarContainerView = CalendarContainerView(
        selectedDate: .constant(nil),
        availableDates: [],
        showAllDates: .constant(true)
    )
    // Keep a strong reference to the hosting controller
    private var hostingController: UIHostingController<CalendarContainerView>!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "iOS Dev Calendar"
        setupFilterMenu()
        setupInitialCalendarView()
    }

    private func setupFilterMenu() { /* …unchanged… */ }

    private func setupInitialCalendarView() {
        showAllDates = true
        filteredDates = availableDates

        // Create the calendar view with proper bindings
        calendarView = CalendarContainerView(
            selectedDate: Binding(
                get: {
                    print("📅 Getting selectedDate: \(String(describing: self.selectedDate))")
                    return self.selectedDate
                },
                set: { newValue in
                    print("📅 Setting selectedDate to: \(String(describing: newValue))")
                    self.selectedDate = newValue
                }
            ),
            availableDates: filteredDates,
            showAllDates: Binding(
                get: { self.showAllDates },
                set: { self.showAllDates = $0 }
            )
        )

        // Create the hosting controller ONCE
        let host = UIHostingController(rootView: calendarView)
        hostingController = host
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        host.didMove(toParent: self)
    }

    private func filterByType(_ type: DayType) {
        showAllDates = false
        currentFilter = type
        filteredDates = availableDates.filter {
            DayType.from($0.label) == currentFilter
            || DayType.from($0.label) == .holiday
        }

        // Instead of recreating the hosting controller, just update the calendar view
        calendarView = CalendarContainerView(
            selectedDate: Binding(get: {
                print("📆 Getting selectedDate: \(String(describing: self.selectedDate))")
                return self.selectedDate
            },
            set: { newValue in
                print("📆 Setting selectedDate to: \(String(describing: newValue))")
                self.selectedDate = newValue
            }),
            availableDates: filteredDates,
            showAllDates: Binding(get: { self.showAllDates },
                                set: { self.showAllDates = $0 })
        )

        // Update the root view instead of recreating the controller
        hostingController.rootView = calendarView
    }
}
