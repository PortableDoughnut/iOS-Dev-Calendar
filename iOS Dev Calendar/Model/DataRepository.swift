//
//  DataRepository.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import Foundation

class DataRepository {
    static let shared = DataRepository()
    
    private(set) var calendarEntries: [CalendarEntryModel] = []
    private(set) var scopeAndSequence: [ScopeAndSequenceEntry] = []
    private(set) var codeChallenges: [CodeChallengeEntry] = []
    private(set) var reviewTopics: [ReviewTopicEntry] = []
    private(set) var wordsOfTheDay: [WordOfTheDay] = []
    
    // Computed property to convert CalendarEntryModel to CalendarDateModel
    var calendarDates: [CalendarDateModel] {
        calendarEntries.map { entry in
            // Find matching scope and sequence entry for this date
            let scope = scopeAndSequence.first { $0.dayID == entry.item }
            
            return CalendarDateModel(
                date: entry.date,
                label: entry.label,
                topic: scope?.topic ?? "",
                outline: scope?.objectives,
                homework: scope?.homeworkDue,
                instructor: nil
            )
        }
    }
    
    private init() {
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            // Load all required data from remote URLs
            print("📥 Loading calendar entries...")
            calendarEntries = try await JSONLoader.load("Calendar")
            print("✅ Loaded \(calendarEntries.count) calendar entries")
            
            print("📥 Loading scope and sequence...")
            scopeAndSequence = try await JSONLoader.load("ScopeAndSequence")
            print("✅ Loaded \(scopeAndSequence.count) scope and sequence entries")
            
            print("📥 Loading code challenges...")
            codeChallenges = try await JSONLoader.load("CodeChallenges")
            print("✅ Loaded \(codeChallenges.count) code challenges")
            
            print("📥 Loading review topics...")
            reviewTopics = try await JSONLoader.load("ReviewTopics")
            print("✅ Loaded \(reviewTopics.count) review topics")
            
            print("📥 Loading words of the day...")
            wordsOfTheDay = try await JSONLoader.load("WordOfTheDay")
            print("✅ Loaded \(wordsOfTheDay.count) words of the day")
            
            print("✅ Successfully loaded all data from remote sources")
        } catch {
            print("❌ Error loading data: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    func scope(for date: Date) -> ScopeAndSequenceEntry? {
        // First find the calendar entry for today
        guard let calendarEntry = calendarEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) else {
            print("⚠️ No calendar entry found for date \(date)")
            return nil
        }
        
        // Then find the scope entry that matches the item from the calendar
        let entry = scopeAndSequence.first { $0.dayID == calendarEntry.item }
        if let entry = entry {
            print("📚 Found scope entry for item \(calendarEntry.item): \(entry)")
        } else {
            print("⚠️ No scope entry found for item \(calendarEntry.item)")
        }
        return entry
    }
    
    func codeChallenge(forDayID id: String) -> CodeChallengeEntry? {
        let entry = codeChallenges.first { $0.dayID == id }
        if let entry = entry {
            print("💻 Found code challenge for dayID \(id): \(entry)")
        } else {
            print("⚠️ No code challenge found for dayID \(id)")
        }
        return entry
    }
    
    func reviewTopic(for date: Date) -> ReviewTopicEntry? {
        // First find the calendar entry for today
        guard let calendarEntry = calendarEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) else {
            print("⚠️ No calendar entry found for date \(date)")
            return nil
        }
        
        // Then find the review topic that matches the item from the calendar
        let entry = reviewTopics.first { $0.dayID == calendarEntry.item }
        if let entry = entry {
            print("📝 Found review topic for item \(calendarEntry.item): \(entry)")
        } else {
            print("⚠️ No review topic found for item \(calendarEntry.item)")
        }
        return entry
    }
    
    func wordOfTheDay(for date: Date) -> WordOfTheDay? {
        // First find the calendar entry for today
        guard let calendarEntry = calendarEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) else {
            print("⚠️ No calendar entry found for date \(date)")
            return nil
        }
        
        // Then find the word of the day that matches the item from the calendar
        let entry = wordsOfTheDay.first { $0.dayID == calendarEntry.item }
        if let entry = entry {
            print("🔤 Found word of the day for item \(calendarEntry.item): \(entry)")
        } else {
            print("⚠️ No word of the day found for item \(calendarEntry.item)")
        }
        return entry
    }
}
