//
//  DataRepository.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//


import Foundation

final class DataRepository {
  static let shared = DataRepository()
  
  let calendarEntries: [CalendarEntry]
  let wordOfTheDay: [WordOfTheDay]
  let scopeAndSequence: [ScopeAndSequenceEntry]
  let reviewTopics: [ReviewTopicEntry]
  let codeChallenges: [CodeChallengeEntry]
  
  private init() {
    // load or crash early in dev
    calendarEntries = (try? JSONLoader.load("Calendar.json", as: [CalendarEntry].self)) ?? []
    print("📅 Loaded \(calendarEntries.count) calendar entries")
    wordOfTheDay    = (try? JSONLoader.load("WordOfTheDay.json", as: [WordOfTheDay].self))    ?? []
    scopeAndSequence = (try? JSONLoader.load("ScopeAndSequence.json", as: [ScopeAndSequenceEntry].self)) ?? []
    reviewTopics    = (try? JSONLoader.load("ReviewTopics.json", as: [ReviewTopicEntry].self)) ?? []
    codeChallenges = (try? JSONLoader.load("CodeChallenges.json", as: [CodeChallengeEntry].self)) ?? []
  }
  
  // helper to lookup details by dayID
  func scope(for dayID: String) -> ScopeAndSequenceEntry? {
    scopeAndSequence.first { $0.dayID == dayID }
  }
  func reviewTopic(for dayID: String) -> String? {
    reviewTopics.first { $0.dayID == dayID }?.reviewTopic
  }
  func codeChallenge(for dayID: String) -> String? {
    codeChallenges.first { $0.dayID == dayID }?.fileName
  }
}
