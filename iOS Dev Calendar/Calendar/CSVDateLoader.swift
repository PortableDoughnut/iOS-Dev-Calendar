////
////  CSVDateLoader.swift
////  iOS Dev Calendar
////
////  Created by Wesley Keetch on 4/16/25.
////
//
//
//import Foundation
//
//class CSVDateLoader {
//  static func loadDatesFromCSV() -> [CalendarDate] {
//    guard let path = Bundle.main.path(forResource: "Winter 2025 Master Sheet - Calendar", ofType: "csv") else {
//      print("⚠️ CSV file not found in bundle.")
//      return []
//    }
//
//    var results: [CalendarDate] = []
//    print("🔍 Starting CSV parsing...")
//
//    do {
//      let fileURL = URL(fileURLWithPath: path)
//      let content = try String(contentsOf: fileURL, encoding: .utf8)
//
//      // Split content by newlines and remove empty lines
//      let lines = content.components(separatedBy: .newlines)
//        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
//
//      print("📄 Total lines found: \(lines.count)")
//
//      //TODO: This works for now, but I wonder if there's a more robust way to figure out where these header rows are, or if we should just change the original spreadsheet to not have those rows. Right now it depends on a magic number.
//
//      // Skip the header rows (first 3 lines)
//      let dataLines = Array(lines.dropFirst(3))
//
//      let segmentSize = 9
//      for line in dataLines {
//        let components = line.components(separatedBy: ",")
//          .map { $0.trimmingCharacters(in: .whitespaces) }
//        let totalSegments = components.count / segmentSize
//        for segment in 0..<totalSegments {
//          let start = segment * segmentSize
//          let end = min(start + segmentSize, components.count)
//          guard start < end else {
//            print("⚠️ Skipping segment \(segment): not enough elements")
//            continue
//          }
//          let segmentComponents = Array(components[start..<end])
//          let label = segmentComponents[0]
//          let dateString = segmentComponents[2]
//
//          if label.isEmpty || dateString.isEmpty || label.uppercased().starts(with: "WEEK") || label.uppercased() == "LEGEND:" || label.uppercased() == "DAY" || label.uppercased() == "DATE" {
//            print("⚠️ Skipping segment: [\(label)], date: [\(dateString)]")
//            continue
//          }
//
//          if let date = parseDateFromString(dateString) {
//            let topic = segmentComponents[4]
//            let outline = segmentComponents[5]
//            let homework = segmentComponents[6]
//            let instructor = segmentComponents[7]
//
//            let calendarDate = CalendarDate(
//              date: date,
//              label: label,
//              topic: topic,
//              outline: outline,
//              homework: homework,
//              instructor: instructor
//            )
//            results.append(calendarDate)
//            print("📅 Loaded: \(label) on \(date)")
//          } else {
//            print("⚠️ Could not parse date from segment: \(label), date: \(dateString)")
//          }
//        }
//      }
//
//      // Sort results by date
//      results.sort { $0.date < $1.date }
//
//      print("\n✅ Successfully loaded \(results.count) dates from CSV")
//
//      // Group and print summary by type
//      let types = Dictionary(grouping: results) { DayType.from($0.label) }
//      print("\n📊 Summary of loaded types:")
//      types.forEach { (type, dates) in
//        print("- \(type.rawValue): \(dates.count) dates")
//      }
//
//      // Print date range
//      if let firstDate = results.first?.date,
//         let lastDate = results.last?.date {
//        print("\n📅 Date range: \(firstDate.formatted(date: .long, time: .omitted)) to \(lastDate.formatted(date: .long, time: .omitted))")
//      }
//
//    } catch {
//      print("❌ Failed to load CSV: \(error)")
//    }
//
//    return results
//  }
//
//  private static func parseDateFromString(_ dateString: String) -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale(identifier: "en_US")
//    dateFormatter.timeZone = TimeZone(identifier: "America/Denver")
//
//    let cleanDateString = dateString.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    // Skip invalid strings
//    let skipStrings = ["DATE", "All Labs", "Drop Deadline", ""]
//    guard !skipStrings.contains(cleanDateString) else {
//      return nil
//    }
//
//    // Try common date formats
//    let dateFormats = ["M/d/yyyy", "M/d/yy"]
//
//    for format in dateFormats {
//      dateFormatter.dateFormat = format
//      if let date = dateFormatter.date(from: cleanDateString) {
//        return date
//      }
//    }
//
//    return nil
//  }
//}
//
//private extension Array {
//  subscript(safe index: Int) -> Element? {
//    return indices.contains(index) ? self[index] : nil
//  }
//}
//
////TODO: Long term, we should consider building a separate tool that allows us to edit the calendar and generate JSON instead of depending on finicky CSV data from a sheet that wasn't really meant to handle it, but this is a great solution in the meantime.
