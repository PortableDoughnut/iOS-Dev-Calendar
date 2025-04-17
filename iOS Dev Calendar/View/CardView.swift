import UIKit

	/// Card for displaying information in a visually intriguing way
class CardView: UIView {
		// MARK: - Properties
	private var cardModel: CardModel
	
		// MARK: - UI Elements
	private let titleLabel = UILabel()
	private let subtitleLabel = UILabel()
	
		// MARK: - Initialization
		/// - Parameter cardModel: Paramaters containing the card options
	init(cardModel: CardModel) {
		self.cardModel = cardModel
		super.init(frame: .zero)
		setupView()
		configureWithModel(cardModel)
	}
	
	required init?(coder: NSCoder) {
		self.cardModel = CardModel(
			title: "Placeholder Title",
			subtitle: "Placeholder Subtitle",
			backgroundColor: .systemGray5,
			buttonTitle: nil
		)
		super.init(coder: coder)
		setupView()
		configureWithModel(cardModel)
	}
	
		// MARK: - Setup
	private func setupView() {
		layer.cornerRadius = 16
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.1
		layer.shadowOffset = CGSize(width: 0, height: 4)
		layer.shadowRadius = 8
		clipsToBounds = false
		
		titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
		titleLabel.numberOfLines = 0
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.isAccessibilityElement = true
		titleLabel.accessibilityTraits = .header
		
		subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let mainStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
		mainStack.axis = .vertical
		mainStack.alignment = .leading
		mainStack.spacing = 8
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(mainStack)
		
		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
			mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
		])
	}
	
		/// Configuration for card view
		/// - Parameter cardModel: Settings for the card
	func configureWithModel(_ cardModel: CardModel) {
		self.cardModel = cardModel
		titleLabel.text = cardModel.title
		subtitleLabel.text = cardModel.subtitle
		backgroundColor = cardModel.backgroundColor ?? .systemBackground
		
			// Dynamically adjust text color based on background brightness
		if let bgColor = cardModel.backgroundColor {
			let brightness = bgColor.brightness
				// If the background is dark, make text light; if light, make text dark
			let textColor: UIColor = brightness < 0.5 ? .white : .black
			titleLabel.textColor = textColor
			subtitleLabel.textColor = textColor.withAlphaComponent(0.7) // Slightly lighter subtitle
		}
	}
}

extension UIColor {
	var brightness: CGFloat {
		var white: CGFloat = 0
		var alpha: CGFloat = 0
		getWhite(&white, alpha: &alpha)
		return white
	}
}
