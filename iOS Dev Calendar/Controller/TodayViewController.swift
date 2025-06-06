//
//  TodayViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.
//

import UIKit

class TodayViewController: UIViewController {
    // Outlets for the various card views displayed on the screen
    // Each card corresponds to a different type of information for the day
    @IBOutlet weak var CodeChallengeCard: CardView!          // Card displaying the daily coding challenge
    @IBOutlet weak var TonightsHomeworkView: CardView!       // Card showing tonight's homework reading assignment
    @IBOutlet weak var DueHomeworkCardView: CardView!         // Card showing homework due for today
    @IBOutlet weak var ReviewCardView: CardView!              // Card containing review topics for the day
    @IBOutlet weak var GoalCardView: CardView!                // Card displaying the word of the day (goal)
    @IBOutlet weak var TeacherCardView: CardView!             // Card showing lesson objectives or teacher notes
    @IBOutlet weak var LessonCardView: CardView!              // Card showing the lesson topic
    
    // Variables to hold the data for the current day, to be displayed in the cards
    var dayID: String = ""             // Identifier for the current day, used to look up data
    var color: String = ""             // Color associated with today's lesson (used for card background)
    var topic: String = ""             // Topic of today's lesson
    var readingDue: String = ""        // Reading due today
    var assignmentsDue: String = ""       // Homework due today
    var objectives: String = ""        // Objectives or goals for today's lesson
    var CodeChallenge: String = ""     // Filename or description of today's code challenge
    var review: String = ""            // Review topic for today
    var wordOfTheDay: String = ""      // Word of the day
    
    var repository: DataRepository = .shared
    var todayEntry: CalendarEntryModel?
    
    // Enum representing the different types of cards displayed in the UI
    // Each case corresponds to a card and provides a title and background color
    enum CardType {
        case lesson, goal, word, review, dueHomework, dueReading, codeChallenge
        
        // Title to display on the card header, based on card type
        var title: String {
            switch self {
            case .lesson: return "Lesson"
            case .goal: return "Word of the Day"
            case .word: return "Goal"
            case .review: return "Review"
            case .dueHomework: return "Homework Due"
            case .dueReading: return "Reading Due"
            case .codeChallenge: return "Code Challenge"
            }
        }
        
        // Background color for the card, customized per card type for visual distinction
        var backgroundColor: UIColor {
            switch self {
            case .lesson: return UIColor(red: 0.43, green: 0.11, blue: 0.14, alpha: 1.0)
            case .goal: return UIColor(red: 0.95, green: 0.79, blue: 0.41, alpha: 1.0)
            case .word: return UIColor(red: 0.17, green: 0.18, blue: 0.26, alpha: 1.0)
            case .review: return UIColor(red: 0.55, green: 0.55, blue: 0.54, alpha: 1.0)
            case .dueHomework: return UIColor(red: 0.84, green: 0.62, blue: 0.60, alpha: 1.0)
            case .dueReading: return UIColor(red: 0.95, green: 0.84, blue: 0.84, alpha: 1.0)
            case .codeChallenge: return UIColor(red: 0.30, green: 0.42, blue: 0.31, alpha: 1.0)
            }
        }
    }
    
    /// Configures a card view with the appropriate title, subtitle, and background color
    /// - Parameters:
    ///   - cardView: The card view to configure (optional)
    ///   - type: The type of card (determines title and default color)
    ///   - subtitle: The subtitle text to display on the card
    ///   - color: Optional custom background color; if not provided, uses default color for the type
    func configureCardView(_ cardView: CardView?, type: CardType, subtitle: String, color: UIColor? = nil) {
        // Create a CardModel instance with the title, subtitle, and background color
        let model = CardModel(
            title: type.title,
            subtitle: subtitle,
            backgroundColor: color ?? type.backgroundColor
        )
        // Configure the card view with the model data
        cardView?.configureWithModel(model)
    }
    
    // Called after the view has been loaded into memory
    // Sets up data, titles, and card views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load and prepare data for today's display
        setupData()
        // Setup the navigation bar titles with date
        setupTitles()
        // Configure all card views with the loaded data
        setupCards()
    }
    
    /// Sets up the navigation bar title and enables large titles for better readability
    func setupTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Format the current date as a long style string (e.g., "April 15, 2025")
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateString = formatter.string(from: Date())
        
        // Set the navigation title to the formatted date string
        navigationItem.title = dateString
    }
    
    /// Configures each card view with the appropriate data for today
    func setupCards() {
        // Configure the lesson card with the topic and color from today's data
        configureCardView(LessonCardView, type: .lesson, subtitle: topic, color: UIColor(named: color))
        // Configure the goal card with the word of the day
        configureCardView(GoalCardView, type: .goal, subtitle: wordOfTheDay)
        // Configure the teacher card with lesson objectives
        configureCardView(TeacherCardView, type: .word, subtitle: objectives)
        // Configure the review card with the review topic
        configureCardView(ReviewCardView, type: .review, subtitle: review)
        // Configure the homework due card with homework due today
        configureCardView(DueHomeworkCardView, type: .dueHomework, subtitle: assignmentsDue)
        // Configure the reading due card with reading due tonight
        configureCardView(TonightsHomeworkView, type: .dueReading, subtitle: readingDue)
        // Configure the code challenge card with today's code challenge
        configureCardView(CodeChallengeCard, type: .codeChallenge, subtitle: CodeChallenge)
    }
    
    /// Loads data from repository and sets up the properties for today's information
    func setupData() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Get today's entry
        todayEntry = repository.calendarEntries.first { 
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }
        
        guard let dayID = todayEntry?.item else {
            print("Could not find calendar entry for today")
            return
        }
        
        // Get scope and sequence
        if let todayScope = repository.scope(for: dayID) {
            topic = todayScope.topic.isEmpty ? "N/A" : todayScope.topic
            readingDue = todayScope.readingDue.isEmpty ? "N/A" : todayScope.readingDue
            assignmentsDue = todayScope.assignmentsDue.isEmpty ? "N/A" : todayScope.assignmentsDue
            objectives = todayScope.objectives.isEmpty ? "N/A" : todayScope.objectives
        }
        
        // Get other data using repository helpers
        CodeChallenge = repository.codeChallenge(for: dayID)?.fileName ?? "N/A"
        review = repository.reviewTopic(for: dayID)?.reviewTopic ?? "N/A"
        
        // Get random word of the day
        if !repository.wordOfTheDay.isEmpty {
            let wordToday = repository.wordOfTheDay[Int.random(in: 0..<repository.wordOfTheDay.count)]
            wordOfTheDay = wordToday.word.isEmpty ? "N/A" : wordToday.word
        } else {
            wordOfTheDay = "N/A"
        }
    }
}
