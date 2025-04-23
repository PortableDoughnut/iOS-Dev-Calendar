//
//  DayType.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/16/25.
//


import SwiftUI

enum DayType: String {
  case sf = "SF"
  case tp = "TP"
  case nd = "ND"
  case st = "ST"
  case tt = "TT"
  case fa = "FA"
  case pc = "PC"
  case gc = "GC"
  case holiday = "HOLIDAY"
  case other

  var color: Color {
    switch self {
    case .sf:
      return .blue
    case .tp:
      return .green
    case .nd:
      return .yellow
    case .st:
      return .orange
    case .tt:
      return .red
    case .fa:
      return .pink
    case .pc:
      return .purple
    case .gc:
      return .mint
    case .holiday:
      return Color(.systemGray3)
    case .other:
      return .gray
    }
  }

  static func from(_ label: String) -> DayType {
    // print("🔍 Processing label: \(label)") // Debug print

    // First, check if it's a holiday
    if label.uppercased() == "HOLIDAY" {
      // print("✓ Found holiday")
      return .holiday
    }

    // For class types, get the letters before any numbers
    let typeString = String(label.prefix(while: { $0.isLetter })).uppercased()
    // print("📝 Extracted type string: \(typeString)")

    let type = DayType(rawValue: typeString) ?? .other
    // print("🎯 Determined type: \(type)")

    return type
  }
}
