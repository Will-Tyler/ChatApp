//
//  ContactsViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var contactsTableView: UITableView = {
		let table = UITableView()

		table.allowsMultipleSelection = false
		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Colors.background
		table.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.cellID)

		return table
	}()
	private lazy var addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemAction))
	private lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneItemAction))
	private lazy var emailField = AddContactView()
	private var emailFieldHeight: NSLayoutConstraint!

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		view.addSubview(contactsTableView)
		view.addSubview(emailField)

		let safeArea = view.safeAreaLayoutGuide

		emailField.translatesAutoresizingMaskIntoConstraints = false
		emailField.topAnchor.constraint(equalTo: safeArea.topAnchor).activate()
		emailField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).activate()
		emailField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).activate()

		emailFieldHeight = emailField.heightAnchor.constraint(equalToConstant: 0)
		emailFieldHeight.activate()

		contactsTableView.translatesAutoresizingMaskIntoConstraints = false
		contactsTableView.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
		contactsTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
		contactsTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
		contactsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	override var title: String? {
		get {
			return "Contacts"
		}
		set {}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background

		switch mode {
		case .select:
			contactsTableView.allowsMultipleSelection = true

		case .view:
			navigationItem.setRightBarButton(addItem, animated: true)
		}

		setupInitialLayout()
		observeContacts()
	}

	var mode: ContactsViewControllerMode = .view
	var delegate: ContactsViewControllerDelegate!

	private var contacts = [User]()

	private func observeContacts() {
		Firebase.observeContacts(with: { contact in
			let path = IndexPath(row: self.contacts.count, section: 0)

			self.contacts.append(contact)
			self.contactsTableView.insertRows(at: [path], with: .automatic)
		})

		Firebase.handleContactRemoved(with: { contact in
			let indices = self.contacts.indices(where: { contact == $0 })
			let paths = indices.map({ return IndexPath(row: $0, section: 0) })

			self.contacts.remove(at: indices)
			self.contactsTableView.deleteRows(at: paths, with: .automatic)
		})
	}

	private func toggleEmailFieldHeight() {
		let oldConstant = emailFieldHeight.constant
		let newConstant = oldConstant == 0 ? emailField.intrinsicContentSize.height : 0

		emailFieldHeight.constant = newConstant
	}

	@objc
	private func addItemAction() {
		toggleEmailFieldHeight()
		emailField.becomeFirstResponder()

		navigationItem.setRightBarButton(doneItem, animated: true)
	}
	@objc
	private func doneItemAction() {
		emailField.resignFirstResponder()
		toggleEmailFieldHeight()

		navigationItem.setRightBarButton(addItem, animated: true)

		if let email = emailField.email {
			Firebase.addContact(email: email, failHandler: {
				self.alertUser(title: "No User Found", message: "A user with the email '\(email)' could not be found.")
			})
		}
		else {
			alertUser(title: "Invalid Email", message: "You must enter a valid email address.")
		}
	}
	@objc
	private func selectItemAction() {
		guard let navigationController = self.navigationController else {
			print("Expected a navigation controller but found none...")
			return
		}

		navigationController.popViewController(animated: true)

		guard let newChatViewController = navigationController.topViewController as? NewChatViewController else {
			print("Expected a NewChatViewController but could not cast...")
			return
		}

		newChatViewController.tableView.reloadData()
	}

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.cellID, for: indexPath) as! UsersTableViewCell
		let user = contacts[indexPath.row]

		cell.textLabel!.text = user.displayName

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if mode == .view {
			contactsTableView.deselectRow(at: indexPath, animated: true)
		}
		else { // mode == .select
			delegate.didSelect(contact: contacts[indexPath.row])
		}
	}
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if mode == .select {
			delegate.didDeselect(contact: contacts[indexPath.row])
		}
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			let removed = contacts.remove(at: indexPath.row)

			contactsTableView.deleteRows(at: [indexPath], with: .automatic)
			Firebase.removeContact(contact: removed)
		}
	}

}


protocol ContactsViewControllerDelegate {

	func didSelect(contact: User)
	func didDeselect(contact: User)

}


enum ContactsViewControllerMode {

	case view
	case select

}
