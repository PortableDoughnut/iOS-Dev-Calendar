//
//  ScopeAndSequenceEntry.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

struct ScopeAndSequenceEntry: Codable {
  let dayID: String
  let color: String
  let topic: String
  let readingDue: String
  let homeworkDue: String
  let objectives: String
}
