//
//  BookView.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/25/25.
//


import UIKit

class BookView: UIView {
	
	// MARK: - Properties
	var linkURL: String?
	
	private let coverImageView = UIImageView()
	private let pagesBehind = UIView()
	private let shadowView = UIView()
	
	// MARK: - Initialization
		/// View for a book
		/// - Parameters:
		///   - coverImage: The cover to be used to represent the book
		///   - link: The link that will be opened when the book is tapped
	init(coverImage: UIImage, link: String) {
		super.init(frame: .zero)
		self.linkURL = link
		setupView(coverImage: coverImage)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
		/// Add a book to the view
		/// - Parameter coverImage: The image to use for the cover of the book
	private func setupView(coverImage: UIImage) {
		// Setup shadow view
		shadowView.backgroundColor = .clear
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
		shadowView.layer.shadowRadius = 8
		shadowView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.2
		shadowView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(shadowView)
		
		// Setup pages behind
		pagesBehind.backgroundColor = UIColor(named: "resource-card")
		pagesBehind.layer.cornerRadius = 12
		pagesBehind.translatesAutoresizingMaskIntoConstraints = false
		shadowView.addSubview(pagesBehind)
		
		// Setup cover image
		coverImageView.image = coverImage
		coverImageView.contentMode = .scaleAspectFit
		coverImageView.clipsToBounds = true
		coverImageView.layer.cornerRadius = 12
		coverImageView.translatesAutoresizingMaskIntoConstraints = false
		shadowView.addSubview(coverImageView)
		
		// Layout constraints
		NSLayoutConstraint.activate([
			shadowView.topAnchor.constraint(equalTo: topAnchor),
			shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
			shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
			shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			pagesBehind.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 8),
			pagesBehind.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 8),
			pagesBehind.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -8),
			pagesBehind.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
			
			coverImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
			coverImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
			coverImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
		])
	}
	
	// MARK: - Dark Mode Support
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
			shadowView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.2
		}
	}
	
	// I added this to make sure that it opens in the app
	@objc private func openBook() {
		if let link = linkURL, let url = URL(string: link) {
			UIApplication.shared.open(url)
		}
	}
}
