//
//  CalendarViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.


import UIKit
import SwiftUI
import MijickCalendarView

class CalendarViewController: UIViewController {
    private var selectedDate: Date?
    private var availableDates: [CalendarDateModel] = DataRepository.shared.calendarEntries.map {
        CalendarDateModel(date: $0.date, label: $0.label)
    }
    private var showAllDates: Bool = true
    private var currentFilter: DayType?

    private var hostingController: UIHostingController<CalendarContainerView>?


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "iOS Dev Calendar"
        setupFilterMenu()
        setupCalendarView()
    }

    private func setupFilterMenu() { /* …unchanged… */ }

    private func filterByType(_ type: DayType) {
        showAllDates = false
        currentFilter = type
        setupCalendarView()
    }

    private func setupCalendarView() {
        // clean up old host
        hostingController?.willMove(toParent: nil)
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        // apply your filter
        let filtered = showAllDates
        ? availableDates
        : availableDates.filter {
            DayType.from($0.label) == currentFilter
            || DayType.from($0.label) == .holiday
        }

        // instantiate your SwiftUI container
        let calendarView = CalendarContainerView(
            selectedDate: Binding(get: { self.selectedDate },
                                  set: { self.selectedDate = $0 }),
            availableDates: filtered,
            showAllDates: Binding(get: { self.showAllDates },
                                  set: { self.showAllDates = $0 })
        )

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

}
