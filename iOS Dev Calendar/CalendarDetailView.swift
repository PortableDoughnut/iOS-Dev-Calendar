//
//  CalendarDetailView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//


import UIKit

class CalendarDetailViewController: UITableViewController {
  private let calendarDate: CalendarDate

  init(calendarDate: CalendarDate) {
    self.calendarDate = calendarDate
    super.init(style: .insetGrouped)
    self.title = calendarDate.label
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  enum RowType: Int, CaseIterable {
    case date
    case type
    case topic
    case outline
    case homework
    case instructor

    var title: String {
      switch self {
      case .date: return "Date"
      case .type: return "Type"
      case .topic: return "Topic"
      case .outline: return "Outline"
      case .homework: return "Homework"
      case .instructor: return "Instructor"
      }
    }

    var value: ((CalendarDate) -> String?) {
      switch self {
      case .date: return { date in
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date.date)
      }
      case .type: return { date in date.label }
      case .topic: return { date in date.topic }
      case .outline: return { date in date.outline }
      case .homework: return { date in date.homework }
      case .instructor: return { date in date.instructor }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RowType.allCases.filter { type in
      if case .homework = type {
        return calendarDate.homework != nil
      }
      if case .outline = type {
        return calendarDate.outline != nil
      }
      if case .instructor = type {
        return calendarDate.instructor != nil
      }
      return true
    }.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    let availableTypes = RowType.allCases.filter { type in
      if case .homework = type {
        return calendarDate.homework != nil
      }
      if case .outline = type {
        return calendarDate.outline != nil
      }
      if case .instructor = type {
        return calendarDate.instructor != nil
      }
      return true
    }

    guard indexPath.row < availableTypes.count else { return cell }
    let rowType = availableTypes[indexPath.row]

    cell.textLabel?.font = .systemFont(ofSize: 16)
    cell.textLabel?.text = rowType.title
    cell.detailTextLabel?.text = rowType.value(calendarDate)

    if case .type = rowType {
      cell.detailTextLabel?.textColor = DayType.from(calendarDate.label).uiColor
    } else {
      cell.detailTextLabel?.textColor = .label
    }

    cell.detailTextLabel?.font = .systemFont(ofSize: 16)
    cell.detailTextLabel?.numberOfLines = 0

    return cell
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Class Information"
  }
}
