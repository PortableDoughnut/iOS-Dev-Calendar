//
//  CalendarViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.
//

import UIKit
import SwiftUI
import MijickCalendarView

class CalendarViewController: UIViewController {
  private var selectedDate: Date? = nil
  private var selectedRange: MDateRange? = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    let calendarView = CalendarContainerView(
      selectedDate: Binding(
        get: { self.selectedDate },
        set: { self.selectedDate = $0 }
      ),
      selectedRange: Binding(
        get: { self.selectedRange },
        set: { self.selectedRange = $0 }
      )
    )

    let hostingController = UIHostingController(rootView: calendarView)
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)

    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    hostingController.didMove(toParent: self)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CalendarViewController_Previews: PreviewProvider {
  static var previews: some View {
    CalendarViewControllerRepresentable()
      .edgesIgnoringSafeArea(.all)
  }
}

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> CalendarViewController {
    return CalendarViewController()
  }

  func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
  }
}
#endif
