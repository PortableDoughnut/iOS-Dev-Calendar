//
//  Event.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import SwiftUI

struct Event: Equatable, Hashable {
  let name: String
  let range: String
  let color: Color
}

//TODO: Refactor the date range selection to just tasks
