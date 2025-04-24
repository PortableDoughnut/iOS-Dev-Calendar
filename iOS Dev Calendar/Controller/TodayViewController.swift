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
	var homeworkDue: String = ""       // Homework due today
	var objectives: String = ""        // Objectives or goals for today's lesson
	var CodeChallenge: String = ""     // Filename or description of today's code challenge
	var review: String = ""            // Review topic for today
	var wordOfTheDay: String = ""      // Word of the day
	
		// JSONLoader instance used to load data from JSON files
	var jsonLoader: JSONLoader = .init()
	
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
		configureCardView(DueHomeworkCardView, type: .dueHomework, subtitle: homeworkDue)
			// Configure the reading due card with reading due tonight
		configureCardView(TonightsHomeworkView, type: .dueReading, subtitle: readingDue)
			// Configure the code challenge card with today's code challenge
		configureCardView(CodeChallengeCard, type: .codeChallenge, subtitle: CodeChallenge)
	}
	
		/// Loads data from JSON files and sets up the properties for today's information
		/// This method handles loading multiple data sources and matching them with today's date
	func setupData() {
		do {
				// Load calendar entries from Calendar.json
			let calendarEntries: [CalendarEntry] = try JSONLoader.load("Calendar", ext: "json")
				// Load scope and sequence entries from ScopeAndSequence.json
			let scopeAndSequence: [ScopeAndSequenceEntry] = try JSONLoader.load("ScopeAndSequence", ext: "json")
				// Load code challenge data from CodeChallenges.json
			let codeChallengeData: [CodeChallengeEntry] = try JSONLoader.load("CodeChallenges", ext: "json")
				// Load review topics from ReviewTopics.json
			let reviewData: [ReviewTopicEntry] = try JSONLoader.load("ReviewTopics", ext: "json")
				// Load words of the day from WordOfTheDay.json
			let wordData: [WordOfTheDay] = try JSONLoader.load("WordOfTheDay", ext: "json")
			
				// Get the start of the current day to compare dates without time component
			let today = Calendar.current.startOfDay(for: Date())
				// Find the calendar entry for today to get the dayID
			dayID = calendarEntries.first(where: {
				Calendar.current.isDate($0.date, inSameDayAs: today)
			})?.item ?? "" // Use empty string if not found
			
				// Find the code challenge entry corresponding to today's dayID
				// If not found, default to the first code challenge entry
			let codeChallengeToday: CodeChallengeEntry = codeChallengeData.first(where: { $0.dayID == dayID }) ?? codeChallengeData[0]
				// Find the review topic entry for today, defaulting to first if none found
			let reviewToday: ReviewTopicEntry = reviewData.first(where: { $0.dayID == dayID }) ?? reviewData[0]
				// TODO: Change from random to what is assigned that day
				// Select a random word of the day from the loaded word data
			let wordToday: WordOfTheDay = wordData[Int.random(in: 0..<wordData.count)]
			
				// Find the scope and sequence entry matching today's dayID
			if let todayScope = scopeAndSequence.first(where: { $0.dayID == dayID }) {
					// Assign color, topic, reading, homework, objectives, code challenge, review, and word of the day
					// If any field is empty, default to "N/A" to indicate missing data
				color = todayScope.color.isEmpty ? "N/A" : todayScope.color
				topic = todayScope.topic.isEmpty ? "N/A" : todayScope.topic
				readingDue = todayScope.readingDue.isEmpty ? "N/A" : todayScope.readingDue
				homeworkDue = todayScope.homeworkDue.isEmpty ? "N/A" : todayScope.homeworkDue
				objectives = todayScope.objectives.isEmpty ? "N/A" : todayScope.objectives
				CodeChallenge = codeChallengeToday.fileName.isEmpty ? "N/A" : codeChallengeToday.fileName
				review = reviewToday.reviewTopic.isEmpty ? "N/A" : reviewToday.reviewTopic
				wordOfTheDay = wordToday.word.isEmpty ? "N/A" : wordToday.word
			} else {
					// Log a message if no scope and sequence entry was found for today's dayID
				print("Could not find scope and sequence entry for dayID: \(dayID)")
			}
		} catch JSONLoadError.resourceNotFound(let resource) {
				// Handle the case where a JSON resource file was not found
			print("Resource not found: \(resource)")
		} catch JSONLoadError.unreadableData(let url, let error) {
				// Handle errors reading data from a file URL
			print("Could not read data from \(url): \(error)")
		} catch JSONLoadError.decodingFailed(let type, let error) {
				// Handle JSON decoding errors for a specific type
			print("Failed to decode \(type): \(error)")
		} catch {
				// Catch any other unknown errors
			print("Unknown error: \(error)")
		}
	}}
