//
//  CardView.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin


import UIKit

/// Card for displaying information in a visually intriguing way
class CardView: UIView {
    // MARK: - Properties
    private var cardModel: CardModel
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(named: "text-primary")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "text-primary")?.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        clipsToBounds = false
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    /// Configuration for card view
    /// - Parameter cardModel: Settings for the card
    func configureWithModel(_ cardModel: CardModel) {
        self.cardModel = cardModel
        titleLabel.text = cardModel.title
        subtitleLabel.text = cardModel.subtitle
        
        // Set background color with animation
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = cardModel.backgroundColor ?? .systemBackground
        }
        
        // Add button if needed
        if let buttonTitle = cardModel.buttonTitle {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            button.setTitleColor(UIColor(named: "text-primary"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update shadow for dark mode
        layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.1
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
