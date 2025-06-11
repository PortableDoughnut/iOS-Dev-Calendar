//
//  DataRepository.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import Foundation

class DataRepository {
    static let shared = DataRepository()
    
    var calendarEntries: [CalendarEntryModel]
    var wordOfTheDay: [WordOfTheDay]
    var scopeAndSequence: [ScopeAndSequenceEntry]
    var reviewTopics: [ReviewTopicEntry]
    var codeChallenges: [CodeChallengeEntry]
    
    private init() {
        calendarEntries = []
        wordOfTheDay = []
        scopeAndSequence = []
        reviewTopics = []
        codeChallenges = []
        
        Task {
            do {
                try await loadRemoteData()
            } catch {
                // Load cached data
                NSLog("Unable to load remote data; using cached instead. Error: \(error)")
                
                do {
                    try loadCachedData()
                } catch {
                    NSLog("Error loading cached json data: \(error)")
                }
            }
        }
    }
    
    func loadCachedData() throws {
        calendarEntries = try JSONLoader.load("Calendar", as: [CalendarEntryModel].self)
        wordOfTheDay    = try JSONLoader.load("WordOfTheDay", as: [WordOfTheDay].self)
        scopeAndSequence = try JSONLoader.load("ScopeAndSequence", as: [ScopeAndSequenceEntry].self)
        reviewTopics    = try JSONLoader.load("ReviewTopics", as: [ReviewTopicEntry].self)
        codeChallenges = try JSONLoader.load("CodeChallenges", as: [CodeChallengeEntry].self)
    }
    
    func loadRemoteData() async throws {
        let baseURL = URL(string: "https://mtechmobiledevelopment.github.io/Mobile-Development-Lesson-Plans/")!
        
        let cohort = UserDefaults.value(forKey: "selectedCohort") ?? "fall"
        
        let calendarURL = baseURL.appending(path: "data/\(cohort)/Calendar.json")
        calendarEntries = try await JSONLoader.load(
                fromURLString: calendarURL.absoluteString,
                as: [CalendarEntryModel].self
            )
        
        let scopeAndSequenceURL = baseURL.appending(path: "data/ScopeAndSequence.json")
        scopeAndSequence = try await JSONLoader.load(
                fromURLString: scopeAndSequenceURL.absoluteString,
                as: [ScopeAndSequenceEntry].self
            )
        
        let reviewTopicsURL = baseURL.appending(path: "data/ReviewTopics.json")
        reviewTopics = try await JSONLoader.load(
            fromURLString: reviewTopicsURL.absoluteString,
            as: [ReviewTopicEntry].self
        )
        
        let codeChallengesURL = baseURL.appending(path: "data/CodeChallenges.json")
        codeChallenges = try await JSONLoader.load(
            fromURLString: codeChallengesURL.absoluteString,
            as: [CodeChallengeEntry].self
        )
        
        let wordOfTheDayURL = baseURL.appending(path: "data/WordOfTheDay.json")
        wordOfTheDay = try await JSONLoader.load(
            fromURLString: wordOfTheDayURL.absoluteString,
            as: [WordOfTheDay].self
        )
    }
    
    // helper to lookup details by dayID
    func scope(for dayID: String) -> ScopeAndSequenceEntry? {
        scopeAndSequence.first { $0.dayID == dayID }
    }
    func reviewTopic(for dayID: String) -> ReviewTopicEntry? {
        reviewTopics.first { $0.dayID == dayID }
    }
    func codeChallenge(for dayID: String) -> CodeChallengeEntry? {
        codeChallenges.first { $0.dayID == dayID }
    }
    func wordOfTheDay(for dayID: String) -> WordOfTheDay? {
        guard let dayIDIndex = scopeAndSequence.firstIndex(where: { $0.id == dayID }) else { return nil }
        
        return wordOfTheDay[dayIDIndex]
    }
}
