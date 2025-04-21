	//
	//  TodayViewController.swift
	//  iOS Dev Calendar
	//
	//  Created by Gwen Thelin on 4/15/25.
	//

import UIKit

class TodayViewController: UIViewController {
	@IBOutlet weak var CodeChallengeCard: CardView!
	@IBOutlet weak var TonightsHomeworkView: CardView!
	@IBOutlet weak var DueHomeworkCardView: CardView!
	@IBOutlet weak var ReviewCardView: CardView!
	@IBOutlet weak var GoalCardView: CardView!
	@IBOutlet weak var TeacherCardView: CardView!
	@IBOutlet weak var LessonCardView: CardView!
	
	enum CardType {
		case lesson, teacher, goal, review, dueHomework, tonightsHomework, codeChallenge
		
		var title: String {
			switch self {
				case .lesson: return "Lesson"
				case .teacher: return "Teacher"
				case .goal: return "Goal"
				case .review: return "Review"
				case .dueHomework: return "Homework Due"
				case .tonightsHomework: return "Tonight's Homework"
				case .codeChallenge: return "Code Challenge"
			}
		}
		
		var backgroundColor: UIColor {
			switch self {
				case .lesson: return UIColor(red: 0.43, green: 0.11, blue: 0.14, alpha: 1.0)
				case .teacher: return UIColor(red: 0.95, green: 0.79, blue: 0.41, alpha: 1.0)
				case .goal: return UIColor(red: 0.17, green: 0.18, blue: 0.26, alpha: 1.0)
				case .review: return UIColor(red: 0.55, green: 0.55, blue: 0.54, alpha: 1.0)
				case .dueHomework: return UIColor(red: 0.84, green: 0.62, blue: 0.60, alpha: 1.0)
				case .tonightsHomework: return UIColor(red: 0.95, green: 0.84, blue: 0.84, alpha: 1.0)
				case .codeChallenge: return UIColor(red: 0.30, green: 0.42, blue: 0.31, alpha: 1.0)
			}
		}
	}
	
	func configureCardView(_ cardView: CardView?, type: CardType, subtitle: String) {
		let model = CardModel(
			title: type.title,
			subtitle: subtitle,
			backgroundColor: type.backgroundColor
		)
		cardView?.configureWithModel(model)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTitles()
		setupCards()
	}
	
		/// Sets up the navigaion titles in a seprate funciton to keep things clean
	func setupTitles() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		let dateString = formatter.string(from: Date())
		
		navigationItem.title = dateString
	}
	
		/// Fills the card outlets with data
	func setupCards() {
		configureCardView(LessonCardView, type: .lesson, subtitle: "SOLID")
		configureCardView(TeacherCardView, type: .teacher, subtitle: "Gwen Thelin")
		configureCardView(GoalCardView, type: .goal, subtitle: "Learn SOLID principles")
		configureCardView(ReviewCardView, type: .review, subtitle: "Review notes from yesterday")
		configureCardView(DueHomeworkCardView, type: .dueHomework, subtitle: "Emoji Dictionary")
		configureCardView(TonightsHomeworkView, type: .tonightsHomework, subtitle: "Social Media App")
		configureCardView(CodeChallengeCard, type: .codeChallenge, subtitle: "Build a Calculator")
	}
}
