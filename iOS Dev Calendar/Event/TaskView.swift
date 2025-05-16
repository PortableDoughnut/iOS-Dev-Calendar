//
//  EventsView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import SwiftUI

struct TaskView: View {
    let date: Date
    let entries: [CalendarDateModel]

    // Get dayID for the selected date
    private var dayID: String {
        entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.label ?? ""
    }

    // Hold our loaded data
    @State private var scopeAndSequence: ScopeAndSequenceEntry?
    @State private var codeChallenge: CodeChallengeEntry?
    @State private var reviewTopic: ReviewTopicEntry?
    @State private var wordOfTheDay: WordOfTheDay?

    // Existing code...
    private var todaysEntries: [CalendarDateModel] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Add spacing at the top
                Spacer()
                    .frame(height: 20)

                Text(CalendarHelpers.formattedTitle(for: date))
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)  // Add some extra space after the title

                if let scope = scopeAndSequence {
                    Group {
                        TaskRow(title: "Lesson", subtitle: scope.topic, type: .lesson, color: scope.color)
                        TaskRow(title: "Word of the Day", subtitle: wordOfTheDay?.word ?? "N/A", type: .goal)
                        TaskRow(title: "Objectives", subtitle: scope.objectives, type: .word)
                        TaskRow(title: "Review", subtitle: reviewTopic?.reviewTopic ?? "N/A", type: .review)
                        TaskRow(title: "Homework Due", subtitle: scope.homeworkDue, type: .dueHomework)
                        TaskRow(title: "Reading Due", subtitle: scope.readingDue, type: .dueReading)
                        if let challenge = codeChallenge {
                            TaskRow(title: "Code Challenge", subtitle: challenge.fileName, type: .codeChallenge)
                        }
                    }
                } else {
                    Text("No items for this date")
                        .foregroundColor(.gray)
                        .italic()
                }

                // Add spacing at the bottom
                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        do {
            // Load scope and sequence
            let scopeEntries: [ScopeAndSequenceEntry] = try JSONLoader.load("ScopeAndSequence", ext: "json")
            scopeAndSequence = scopeEntries.first(where: { $0.dayID == dayID })

            // Load code challenges
            let challenges: [CodeChallengeEntry] = try JSONLoader.load("CodeChallenges", ext: "json")
            codeChallenge = challenges.first(where: { $0.dayID == dayID })

            // Load review topics
            let reviews: [ReviewTopicEntry] = try JSONLoader.load("ReviewTopics", ext: "json")
            reviewTopic = reviews.first(where: { $0.dayID == dayID })

            // Load word of the day
            let words: [WordOfTheDay] = try JSONLoader.load("WordOfTheDay", ext: "json")
            wordOfTheDay = words.randomElement()

        } catch {
            print("Failed to load data: \(error)")
        }
    }
}

//TODO: Add SwiftData or way to persist checking off assignments and tasks in the TaskView
