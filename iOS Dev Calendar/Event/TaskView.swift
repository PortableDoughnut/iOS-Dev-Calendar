//
//  EventsView.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import SwiftUI

struct TaskView: View {
    let date: Date
    let entries: [CalendarEntryModel]

    // Get dayID for the selected date
    private var dayID: String {
        entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.item ?? ""
    }

    // Hold our loaded data
    @State private var scopeAndSequence: ScopeAndSequenceEntry?
    @State private var codeChallenge: CodeChallengeEntry?
    @State private var reviewTopic: ReviewTopicEntry?
    @State private var wordOfTheDay: WordOfTheDay?

    // Existing code...
    private var todaysEntries: [CalendarEntryModel] {
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
                        TaskRow(title: "Lesson \(scope.dayID)", subtitle: scope.topic, type: .lesson)
                        TaskRow(title: "Word of the Day", subtitle: wordOfTheDay?.word ?? "N/A", type: .goal)
                        TaskRow(title: "Objectives", subtitle: scope.objectives, type: .word)
                        TaskRow(title: "Review", subtitle: reviewTopic?.reviewTopic ?? "N/A", type: .review)
                        TaskRow(title: "Homework Due", subtitle: scope.assignmentsDue, type: .dueHomework)
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
        // Load scope and sequence
        scopeAndSequence = DataRepository
            .shared.scope(for: dayID)
        
        // Load code challenges
        codeChallenge = DataRepository.shared.codeChallenge(for: dayID)
        
        // Load review topics
        reviewTopic = DataRepository.shared.reviewTopic(for: dayID)
        
        // Load word of the day
        wordOfTheDay = DataRepository.shared.wordOfTheDay(for: dayID)
    }
}

//TODO: Add SwiftData or way to persist checking off assignments and tasks in the TaskView
