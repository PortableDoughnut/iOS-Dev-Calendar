//
//  DataRepository.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import Foundation
import SwiftData

@Model
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
        Task { @MainActor in
            let context = PersistenceController.shared.context
            
            if let dataRepo = try context.fetch(FetchDescriptor<DataRepository>()).first {
                NSLog("Loaded Cached Data")
                self.calendarEntries = dataRepo.calendarEntries
                self.scopeAndSequence = dataRepo.scopeAndSequence
                self.codeChallenges = dataRepo.codeChallenges
                self.wordOfTheDay = dataRepo.wordOfTheDay
                self.reviewTopics = dataRepo.reviewTopics
            }
        }
    }
    
    func loadRemoteData() async throws {
        let cohort = UserDefaults.standard.string(forKey: "selectedCohort") ?? "fall"

        let baseURL = URL(string: "https://mtechmobiledevelopment.github.io/Mobile-Development-Lesson-Plans/data/\(cohort)/")!
        
        let calendarURL = baseURL.appending(path: "Calendar.json")
        calendarEntries = try await JSONLoader.load(
                fromURLString: calendarURL.absoluteString,
                as: [CalendarEntryModel].self
            )
        
        let scopeAndSequenceURL = baseURL.appending(path: "ScopeAndSequence.json")
        scopeAndSequence = try await JSONLoader.load(
                fromURLString: scopeAndSequenceURL.absoluteString,
                as: [ScopeAndSequenceEntry].self
            )
        
        let reviewTopicsURL = baseURL.appending(path: "ReviewTopics.json")
        reviewTopics = try await JSONLoader.load(
            fromURLString: reviewTopicsURL.absoluteString,
            as: [ReviewTopicEntry].self
        )
        
        let codeChallengesURL = baseURL.appending(path: "CodeChallenges.json")
        codeChallenges = try await JSONLoader.load(
            fromURLString: codeChallengesURL.absoluteString,
            as: [CodeChallengeEntry].self
        )
        
        let wordOfTheDayURL = baseURL.appending(path: "WordOfTheDay.json")
        wordOfTheDay = try await JSONLoader.load(
            fromURLString: wordOfTheDayURL.absoluteString,
            as: [WordOfTheDay].self
        )
        
        Task { @MainActor in
            let context = PersistenceController.shared.context
            
            // Delete previous caches
            try context.delete(model: DataRepository.self, where: nil)
            
            context.insert(self)
        }
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

@MainActor
public final class PersistenceController {
    public static let shared = PersistenceController()
    public let container: ModelContainer

    private init() {
        // Configure in-memory vs. on-disk, custom URLs, etc.
        let config = ModelConfiguration(
            for: DataRepository.self,
            isStoredInMemoryOnly: false
        )
        let schema = Schema([DataRepository.self])

        do {
            container = try ModelContainer(for: schema,
                                           configurations: [config])
        } catch {
            fatalError("Unable to create ModelContainer: \(error)")
        }
    }

    /// A convenient context you can hand out to your view controllers
    public var context: ModelContext {
        ModelContext(container)
    }
}
