//
//  CalendarContainerView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//


import SwiftUI
import MijickCalendarView

struct CalendarContainerView: View {
  @Binding var selectedDate: Date?
  @Binding var selectedRange: MDateRange?
  
  var body: some View {
    MCalendarView(selectedDate: $selectedDate, selectedRange: $selectedRange)
  }
}

#if DEBUG
import SwiftUI

struct CalendarContainerView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarContainerView(
      selectedDate: .constant(nil),
      selectedRange: .constant(MDateRange())
    )
    .previewLayout(.sizeThatFits)
  }
}
#endif
