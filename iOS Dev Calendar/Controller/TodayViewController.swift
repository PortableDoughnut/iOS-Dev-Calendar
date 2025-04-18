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
		for (card, model) in [
			(
				LessonCardView,
				CardModel(
					title: "Lesson",
					subtitle: "SOLID",
					backgroundColor: UIColor(red: 0.43, green: 0.11, blue: 0.14, alpha: 1.0)
				)
			),
			(
			TeacherCardView,
			CardModel(
				title: "Teacher",
				subtitle: "Gwen Thelin",
				backgroundColor: UIColor(red: 0.95, green: 0.79, blue: 0.41, alpha: 1.0)
			)
			),
			(
			GoalCardView,
			CardModel(
				title: "Goal",
				subtitle: "Learn SOLID principles",
				backgroundColor: UIColor(red: 0.17, green: 0.18, blue: 0.26, alpha: 1.0)
			)
		),
			(
			ReviewCardView,
			CardModel(
				title: "Review",
				subtitle: "Review notes from yesterday",
				backgroundColor: UIColor(red: 0.55, green: 0.55, blue: 0.54, alpha: 1.0)
			)
			),
			(
				DueHomeworkCardView,
				CardModel(
					title: "Homework Due",
					subtitle: "Emoji Dictionary",
					backgroundColor: UIColor(red: 0.84, green: 0.62, blue: 0.60, alpha: 1.0)
				)
			),
			(
				TonightsHomeworkView,
				CardModel(
					title: "Tonight's Homework",
					subtitle: "Social Media App",
					backgroundColor: UIColor(red: 0.95, green: 0.84, blue: 0.84, alpha: 1.0)
				)
			),
			(
				CodeChallengeCard,
				CardModel(
					title: "Code Challenge",
					subtitle: "Build a Calculator",
					backgroundColor: UIColor(red: 0.30, green: 0.42, blue: 0.31, alpha: 1.0)
				)
			)
		] {
			card?.configureWithModel(model)
		}
	}
}
