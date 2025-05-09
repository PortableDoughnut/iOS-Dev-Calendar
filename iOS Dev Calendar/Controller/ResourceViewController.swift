//
//  ResourceViewController.swift
//  iOS Dev Calendar
//
//  Created by Gwen Thelin on 4/15/25.
//

import UIKit

class ResourceViewController: UIViewController {
	// MARK: - Properties
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
		stack.spacing = 20
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	// MARK: - Data
	private let bookData: [(imageName: String, link: String)] = [
		("bookCover1", "https://books.apple.com/us/book/develop-in-swift-fundamentals/id1581182804"),
		("bookCover2", "https://books.apple.com/us/book/develop-in-swift-data-collections/id1581183203")
	]
	
	private let websiteData: [(title: String, url: String, imageName: String)] = [
		("Apple Developer", "https://developer.apple.com", "appleLogo"),
		("Swift Language Guide", "https://swift.org/documentation/", "swiftLogo")
	]
	
	private let contactData: [(name: String, email: String)] = [
		("Gwen Thelin", "gwen@example.com"),
		("iOS Dev Support", "support@iosdevcalendar.com")
	]
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupScrollView()
		setupContent()
	}
	
	// MARK: - Setup
	private func setupNavigationBar() {
		title = "Resources"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
	}
	
	private func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(stackView)
		
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
	
	private func setupContent() {
		// Books Section
		let booksLabel = createSectionLabel("Books")
		stackView.addArrangedSubview(booksLabel)
		
		let booksStack = UIStackView()
		booksStack.axis = .horizontal
		booksStack.spacing = 16
		booksStack.distribution = .fillEqually
		booksStack.translatesAutoresizingMaskIntoConstraints = false
		
		for data in bookData {
			let book = BookView(coverImage: UIImage(named: data.imageName) ?? UIImage(), link: data.link)
			book.isUserInteractionEnabled = true
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openBook(_:)))
			book.addGestureRecognizer(tapGesture)
			book.translatesAutoresizingMaskIntoConstraints = false
			book.heightAnchor.constraint(equalToConstant: 180).isActive = true
			booksStack.addArrangedSubview(book)
		}
		
		stackView.addArrangedSubview(booksStack)
		
		// Websites Section
		let websitesLabel = createSectionLabel("Useful Websites")
		stackView.addArrangedSubview(websitesLabel)
		
		let webStack = UIStackView()
		webStack.axis = .horizontal
		webStack.spacing = 16
		webStack.distribution = .fillEqually
		webStack.translatesAutoresizingMaskIntoConstraints = false
		
		for site in websiteData {
			let card = createResourceCard(
				title: site.title,
				imageName: site.imageName,
				action: { [weak self] in
					if let url = URL(string: site.url) {
						UIApplication.shared.open(url)
					}
				}
			)
			webStack.addArrangedSubview(card)
		}
		
		stackView.addArrangedSubview(webStack)
		
		// Contact Section
		let contactLabel = createSectionLabel("Contact Info")
		stackView.addArrangedSubview(contactLabel)
		
		let contactStack = UIStackView()
		contactStack.axis = .vertical
		contactStack.spacing = 12
		contactStack.translatesAutoresizingMaskIntoConstraints = false
		
		for contact in contactData {
			let card = createContactCard(name: contact.name, email: contact.email)
			contactStack.addArrangedSubview(card)
		}
		
		stackView.addArrangedSubview(contactStack)
	}
	
	// MARK: - Helper Methods
	private func createSectionLabel(_ text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = UIColor(named: "text-primary")
		return label
	}
	
	private func createResourceCard(title: String, imageName: String, action: @escaping () -> Void) -> UIView {
		let card = UIView()
		card.backgroundColor = UIColor(named: "resource-card")
		card.layer.cornerRadius = 12
		card.layer.shadowColor = UIColor.black.cgColor
		card.layer.shadowOffset = CGSize(width: 0, height: 2)
		card.layer.shadowRadius = 4
		card.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.1
		card.translatesAutoresizingMaskIntoConstraints = false
		
		let imageView = UIImageView(image: UIImage(named: imageName))
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		let label = UILabel()
		label.text = title
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 15, weight: .medium)
		label.textColor = UIColor(named: "text-primary")
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		
		let verticalStack = UIStackView(arrangedSubviews: [imageView, label])
		verticalStack.axis = .vertical
		verticalStack.spacing = 8
		verticalStack.alignment = .center
		verticalStack.translatesAutoresizingMaskIntoConstraints = false
		
		card.addSubview(verticalStack)
		NSLayoutConstraint.activate([
			verticalStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
			verticalStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
			verticalStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
			verticalStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
			imageView.heightAnchor.constraint(equalToConstant: 40)
		])
		
		card.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
		card.addGestureRecognizer(tap)
		card.accessibilityHint = title
		
		return card
	}
	
	private func createContactCard(name: String, email: String) -> UIView {
		let card = UIView()
		card.backgroundColor = UIColor(named: "resource-card")
		card.layer.cornerRadius = 12
		card.layer.shadowColor = UIColor.black.cgColor
		card.layer.shadowOffset = CGSize(width: 0, height: 2)
		card.layer.shadowRadius = 4
		card.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.1
		card.translatesAutoresizingMaskIntoConstraints = false
		
		let nameLabel = UILabel()
		nameLabel.text = name
		nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
		nameLabel.textColor = UIColor(named: "text-primary")
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let emailLabel = UILabel()
		emailLabel.text = email
		emailLabel.font = .systemFont(ofSize: 14)
		emailLabel.textColor = UIColor(named: "text-primary")?.withAlphaComponent(0.8)
		emailLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
		stack.axis = .vertical
		stack.spacing = 4
		stack.alignment = .leading
		stack.translatesAutoresizingMaskIntoConstraints = false
		
		card.addSubview(stack)
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
			stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
			stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
			stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
		])
		
		card.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(contactTapped(_:)))
		card.addGestureRecognizer(tap)
		card.accessibilityHint = email
		
		return card
	}
	
	// MARK: - Actions
	@objc private func openBook(_ sender: UITapGestureRecognizer) {
		guard let bookView = sender.view as? BookView,
			  let link = bookView.linkURL,
			  let url = URL(string: link) else { return }
		UIApplication.shared.open(url)
	}
	
	@objc private func cardTapped(_ sender: UITapGestureRecognizer) {
		guard let view = sender.view,
			  let title = view.accessibilityHint,
			  let site = websiteData.first(where: { $0.title == title }),
			  let url = URL(string: site.url) else { return }
		UIApplication.shared.open(url)
	}
	
	@objc private func contactTapped(_ sender: UITapGestureRecognizer) {
		guard let view = sender.view,
			  let email = view.accessibilityHint,
			  let url = URL(string: "mailto:\(email)") else { return }
		UIApplication.shared.open(url)
	}
	
	// MARK: - Dark Mode Support
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
			// Update shadow opacity for dark mode
			view.subviews.forEach { view in
				if let layer = view.layer as? CALayer {
					layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.1
				}
			}
		}
	}
}
