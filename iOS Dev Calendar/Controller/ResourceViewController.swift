	//
	//  ResourceViewController.swift
	//  iOS Dev Calendar
	//
	//  Created by Gwen Thelin on 4/15/25.
	//

import UIKit

class ResourceViewController: UIViewController {
	
		/// The books for use in the resource view
	let bookData: [(imageName: String, link: String)] = [
		("bookCover1", "https://books.apple.com/us/book/develop-in-swift-fundamentals/id1581182804"),
		("bookCover2", "https://books.apple.com/us/book/develop-in-swift-data-collections/id1581183203")
	]
	
	let websiteData: [(title: String, url: String, imageName: String)] = [
		("Apple Developer", "https://developer.apple.com", "appleLogo"),
		("Swift Language Guide", "https://swift.org/documentation/", "swiftLogo")
	]
	
	let contactData: [(name: String, email: String)] = [
		("Gwen Thelin", "gwen@example.com"),
		("iOS Dev Support", "support@iosdevcalendar.com")
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupShelf()
	}
	
	func setupShelf() {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 20
		stack.translatesAutoresizingMaskIntoConstraints = false
		
			// Add Books label
		let booksLabel = UILabel()
		booksLabel.text = "Books"
		booksLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		booksLabel.textAlignment = .left
		stack.addArrangedSubview(booksLabel)
		
		let booksPerRow = 2
		var rowStack: UIStackView?
		
		for (index, data) in bookData.enumerated() {
			if index % booksPerRow == 0 {
				rowStack = UIStackView()
				rowStack?.axis = .horizontal
				rowStack?.spacing = 16
				rowStack?.distribution = .fillEqually
				rowStack?.translatesAutoresizingMaskIntoConstraints = false
				stack.addArrangedSubview(rowStack!)
			}
			
			let book = BookView(coverImage: UIImage(named: data.imageName) ?? UIImage(), link: data.link)
			book.isUserInteractionEnabled = true
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openBook(_:)))
			book.addGestureRecognizer(tapGesture)
			book.translatesAutoresizingMaskIntoConstraints = false
			book.heightAnchor.constraint(equalToConstant: 180).isActive = true
			rowStack?.addArrangedSubview(book)
		}
		
			// Add Websites label
		let websitesLabel = UILabel()
		websitesLabel.text = "Useful Websites"
		websitesLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		websitesLabel.textAlignment = .left
		stack.addArrangedSubview(websitesLabel)
		
		let webStack = UIStackView()
		webStack.axis = .horizontal
		webStack.spacing = 16
		webStack.distribution = .fillEqually
		webStack.translatesAutoresizingMaskIntoConstraints = false
		
		for site in websiteData {
			let card = UIView()
			card.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
			card.layer.cornerRadius = 12
			card.layer.borderWidth = 1
			card.layer.borderColor = UIColor.systemBlue.cgColor
			card.translatesAutoresizingMaskIntoConstraints = false
			
			let imageView = UIImageView(image: UIImage(named: site.imageName))
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			
			let label = UILabel()
			label.text = site.title
			label.textAlignment = .center
			label.font = UIFont.boldSystemFont(ofSize: 14)
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
			let tap = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
			card.addGestureRecognizer(tap)
			card.accessibilityHint = site.url
			
			webStack.addArrangedSubview(card)
		}
		
		stack.addArrangedSubview(webStack)
		
		let contactLabel = UILabel()
		contactLabel.text = "Contact Info"
		contactLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		contactLabel.textAlignment = .left
		stack.addArrangedSubview(contactLabel)
		
		let contactStack = UIStackView()
		contactStack.axis = .vertical
		contactStack.spacing = 12
		contactStack.distribution = .fillEqually
		contactStack.translatesAutoresizingMaskIntoConstraints = false
		
		for contact in contactData {
			let contactCard = UIView()
			contactCard.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
			contactCard.layer.cornerRadius = 12
			contactCard.layer.borderWidth = 1
			contactCard.layer.borderColor = UIColor.systemPurple.cgColor
			contactCard.translatesAutoresizingMaskIntoConstraints = false
			
			let label = UILabel()
			label.text = "\(contact.name)\n\(contact.email)"
			label.textAlignment = .center
			label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
			label.numberOfLines = 2
			label.translatesAutoresizingMaskIntoConstraints = false
			
			contactCard.addSubview(label)
			NSLayoutConstraint.activate([
				label.topAnchor.constraint(equalTo: contactCard.topAnchor, constant: 12),
				label.leadingAnchor.constraint(equalTo: contactCard.leadingAnchor, constant: 8),
				label.trailingAnchor.constraint(equalTo: contactCard.trailingAnchor, constant: -8),
				label.bottomAnchor.constraint(equalTo: contactCard.bottomAnchor, constant: -12)
			])
			
			contactCard.isUserInteractionEnabled = true
			let tap = UITapGestureRecognizer(target: self, action: #selector(contactTapped(_:)))
			contactCard.addGestureRecognizer(tap)
			contactCard.accessibilityHint = contact.email
			
			contactStack.addArrangedSubview(contactCard)
		}
		
		stack.addArrangedSubview(contactStack)
		
		view.addSubview(stack)
		
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
		])
	}
	
	@objc func openBook(_ sender: UITapGestureRecognizer) {
		guard let bookView = sender.view as? BookView,
			  let link = bookView.linkURL,
			  let url = URL(string: link) else { return }
		UIApplication.shared.open(url)
	}
	
	@objc func openWebsite(_ sender: UITapGestureRecognizer) {
		guard let view = sender.view,
			  let urlString = view.accessibilityHint,
			  let url = URL(string: urlString) else { return }
		UIApplication.shared.open(url)
	}
	
	@objc func contactTapped(_ sender: UITapGestureRecognizer) {
		guard let view = sender.view,
			  let email = view.accessibilityHint,
			  let url = URL(string: "mailto:\(email)") else { return }
		UIApplication.shared.open(url)
	}
	
}
