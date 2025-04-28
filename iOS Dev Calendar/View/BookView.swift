//
//  BookView.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/25/25.
//


import UIKit

class BookView: UIView {
	
	var linkURL: String?
	
	private let coverImageView = UIImageView()
	private let pagesBehind = UIView()
	
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
	
		/// Add a book to the view
		/// - Parameter coverImage: The image to use for the cover of the book
	private func setupView(coverImage: UIImage) {
			// Simulate pages behind the book
		pagesBehind.backgroundColor = UIColor.systemGray4
		pagesBehind.layer.cornerRadius = 10
		pagesBehind.translatesAutoresizingMaskIntoConstraints = false
		addSubview(pagesBehind)
		
		coverImageView.image = coverImage
		coverImageView.contentMode = .scaleAspectFit
		coverImageView.clipsToBounds = true
		coverImageView.layer.cornerRadius = 6
		coverImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(coverImageView)
		
			// Layout constraints with dynamic sizing
		NSLayoutConstraint.activate([
			pagesBehind.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			pagesBehind.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			pagesBehind.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			pagesBehind.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
			
			coverImageView.topAnchor.constraint(equalTo: topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	// I added this to make sure that it opens in the app
	@objc private func openBook() {
		if let link = linkURL, let url = URL(string: link) {
			UIApplication.shared.open(url)
		}
	}
}
