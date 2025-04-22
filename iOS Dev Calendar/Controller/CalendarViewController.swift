//
//  CalendarViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.

//import UIKit
//import SwiftUI
//import MijickCalendarView
//
//class CalendarViewController: UIViewController {
//  private var selectedDate: Date? = nil {
//    didSet {
//      if let date = selectedDate {
//        showDetailForDate(date)
//      }
//    }
//  }
//
//  private var availableDates: [CalendarDate] = []
//  private var showAllDates: Bool = true
//  private var currentFilter: DayType?
//  private var hostingController: UIHostingController<CalendarContainerView>?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Configure navigation bar
//    navigationController?.navigationBar.prefersLargeTitles = false
//    title = "iOS Dev Calendar"
//
//    // Load dates from CSV
//    availableDates = CSVDateLoader.loadDatesFromCSV()
//
//    // Create filter menu
//    setupFilterMenu()
//
//    setupCalendarView()
//  }
//
//  private func setupFilterMenu() {
//    let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")
//
//    // Create menu items for each unit type
//    var menuItems: [UIMenuElement] = []
//
//    // Add "Show All" option
//    menuItems.append(UIAction(title: "Show All", image: UIImage(systemName: "calendar"), handler: { [weak self] _ in
//      self?.showAllDates = true
//      self?.currentFilter = nil
//      self?.setupCalendarView()
//    }))
//
//    //TODO: These codes (SF, TP etc) are abbreviations of the course titles. You can find the full list on the far right of the Calendar google sheet.
//
//    // Add separator
//    let unitActions = [
//      (title: "Swift Fundamentals (SF)", type: DayType.sf, image: "swift"),
//      (title: "Technical Projects (TP)", type: DayType.tp, image: "hammer"),
//      (title: "Network & Data (ND)", type: DayType.nd, image: "network"),
//      (title: "SwiftUI & Tools (ST)", type: DayType.st, image: "macwindow"),
//      (title: "Testing & Tools (TT)", type: DayType.tt, image: "checklist"),
//      (title: "Final Apps (FA)", type: DayType.fa, image: "app"),
//      (title: "Programming Concepts (PC)", type: DayType.pc, image: "book"),
//      (title: "General Concepts (GC)", type: DayType.gc, image: "gear")
//    ]
//
//    let unitMenuItems = unitActions.map { action in
//      UIAction(
//        title: action.title,
//        image: UIImage(systemName: action.image),
//        handler: { [weak self] _ in
//          self?.filterByType(action.type)
//        }
//      )
//    }
//
//    menuItems.append(UIMenu(title: "Units", options: .displayInline, children: unitMenuItems))
//
//    let menu = UIMenu(title: "Filter", image: filterImage, children: menuItems)
//    navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: filterImage, primaryAction: nil, menu: menu)
//  }
//
//  private func filterByType(_ type: DayType) {
//    showAllDates = false
//    currentFilter = type
//    setupCalendarView()
//  }
//
//  private func setupCalendarView() {
//    // Remove existing hosting controller if any
//    hostingController?.removeFromParent()
//    hostingController?.view.removeFromSuperview()
//
//    let filteredDates = showAllDates ? availableDates : availableDates.filter {
//      // Don't filter out holidays when showing specific unit
//      DayType.from($0.label) == currentFilter || DayType.from($0.label) == .holiday
//    }
//
//    let calendarView = CalendarContainerView(
//      selectedDate: Binding(
//        get: { self.selectedDate },
//        set: { self.selectedDate = $0 }
//      ),
//      availableDates: filteredDates,
//      showAllDates: Binding(
//        get: { self.showAllDates },
//        set: { self.showAllDates = $0 }
//      )
//    )
//
//    let newHostingController = UIHostingController(rootView: calendarView)
//    hostingController = newHostingController
//
//    addChild(newHostingController)
//    newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(newHostingController.view)
//
//    NSLayoutConstraint.activate([
//      newHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//      newHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//      newHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      newHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//    ])
//
//    newHostingController.didMove(toParent: self)
//  }
//
//  private func showDetailForDate(_ date: Date) {
//    guard let calendarDate = availableDates.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) else {
//      return
//    }
//
//    let detailViewController = CalendarDetailViewController(calendarDate: calendarDate)
//    navigationController?.pushViewController(detailViewController, animated: true)
//  }
//}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct CalendarViewController_Previews: PreviewProvider {
//  static var previews: some View {
//    CalendarViewControllerRepresentable()
//      .edgesIgnoringSafeArea(.all)
//  }
//}
//
//struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
//  func makeUIViewController(context: Context) -> CalendarViewController {
//    return CalendarViewController()
//  }
//
//  func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
//  }
//}
//#endif
