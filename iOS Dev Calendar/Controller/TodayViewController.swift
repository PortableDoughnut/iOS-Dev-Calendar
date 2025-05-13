
//
//  TodayViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.
//


import UIKit

class TodayViewController: UIViewController {
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // Outlets for the various card views displayed on the screen
    // Each card corresponds to a different type of information for the day
    @IBOutlet weak var CodeChallengeCard: CardView!          // Card displaying the daily coding challenge
    @IBOutlet weak var TonightsHomeworkView: CardView!       // Card showing tonight's homework reading assignment
    @IBOutlet weak var DueHomeworkCardView: CardView!         // Card showing homework due for today
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
    var wordOfTheDay: String = ""      // Word of the day

    // Card types for the UI with their respective titles and colors
    enum CardType {
        case lesson, goal, word, dueHomework, dueReading, codeChallenge

        var title: String {
            switch self {
            case .lesson: return "Lesson"
            case .goal: return "Word of the Day"
            case .word: return "Goal"
            case .dueHomework: return "Homework Due"
            case .dueReading: return "Reading Due"
            case .codeChallenge: return "Code Challenge"
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .lesson: return UIColor(named: "card-primary") ?? .systemBackground
            case .goal: return UIColor(named: "card-primary") ?? .systemBackground
            case .word: return UIColor(named: "card-primary") ?? .systemBackground
            case .dueHomework: return UIColor(named: "card-primary") ?? .systemBackground
            case .dueReading: return UIColor(named: "card-primary") ?? .systemBackground
            case .codeChallenge: return UIColor(named: "card-primary") ?? .systemBackground
            }
        }
        
        var textColor: UIColor {
            return UIColor(named: "text-primary") ?? .label
        }
    }
    
    /// Configures a card view with title, subtitle, and background color
    /// - Parameters:
    ///   - cardView: The card view to configure
    ///   - type: Card type determining title and default color
    ///   - subtitle: Card subtitle text
    ///   - color: Optional custom background color
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupTitles()
        Task {
            await setupData()
            setupCards()
        }
    }
    
    // MARK: - Setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Add all cards to stack view
        let cards = [
            LessonCardView,
            GoalCardView,
            TeacherCardView,
            DueHomeworkCardView,
            TonightsHomeworkView,
            CodeChallengeCard
        ]
        
        cards.forEach { card in
            if let card = card {
                stackView.addArrangedSubview(card)
            }
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTitles() {
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
    
    private func setupCards() {
        // Configure the lesson card with the topic and color from today's data
        configureCardView(LessonCardView, type: .lesson, subtitle: topic, color: UIColor(named: color))
        // Configure the goal card with the word of the day
        configureCardView(GoalCardView, type: .goal, subtitle: wordOfTheDay)
        // Configure the teacher card with lesson objectives
        configureCardView(TeacherCardView, type: .word, subtitle: objectives)
        // Configure the homework due card with homework due today
        configureCardView(DueHomeworkCardView, type: .dueHomework, subtitle: homeworkDue)
        // Configure the reading due card with reading due tonight
        configureCardView(TonightsHomeworkView, type: .dueReading, subtitle: readingDue)
        // Configure the code challenge card with today's code challenge
        configureCardView(CodeChallengeCard, type: .codeChallenge, subtitle: CodeChallenge)
    }
    
    /// Loads data from remote URLs and sets up the properties for today's information
    private func setupData() async {
            // Get today's data
            let today = Calendar.current.startOfDay(for: Date())
            print("📅 Setting up data for date: \(today)")
            
            // Get today's specific entries
            if let todayScope = DataRepository.shared.scope(for: today) {
                print("📚 Found scope for today: \(todayScope)")
                color = todayScope.color.isEmpty ? "N/A" : todayScope.color
                topic = todayScope.topic.isEmpty ? "N/A" : todayScope.topic
                readingDue = todayScope.readingDue.isEmpty ? "N/A" : todayScope.readingDue
                homeworkDue = todayScope.homeworkDue.isEmpty ? "N/A" : todayScope.homeworkDue
                objectives = todayScope.objectives.isEmpty ? "N/A" : todayScope.objectives
            } else {
                print("⚠️ No scope found for today")
            }
            
            if let codeChallengeToday = DataRepository.shared.codeChallenge(forDayID: dayID) {
                print("💻 Found code challenge for day ID \(dayID): \(codeChallengeToday)")
                CodeChallenge = codeChallengeToday.fileName.isEmpty ? "N/A" : codeChallengeToday.fileName
            } else {
                print("⚠️ No code challenge found for day ID \(dayID)")
            }
            
            if let wordToday = DataRepository.shared.wordOfTheDay(for: today) {
                print("🔤 Found word of the day for today: \(wordToday)")
                wordOfTheDay = wordToday.word.isEmpty ? "N/A" : wordToday.word
            } else {
                print("⚠️ No word of the day found for today")
            }
            
            print("✅ Successfully loaded today's data")
            print("📊 Data summary:")
            print("  - Topic: \(topic)")
            print("  - Reading Due: \(readingDue)")
            print("  - Homework Due: \(homeworkDue)")
            print("  - Objectives: \(objectives)")
            print("  - Code Challenge: \(CodeChallenge)")
            print("  - Word of the Day: \(wordOfTheDay)")
    }
}
