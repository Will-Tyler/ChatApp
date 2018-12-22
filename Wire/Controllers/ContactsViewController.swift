//
//  ContactsViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


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

	private let contactsRef = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/contacts")
	private var contacts = [User]()

	private func observeContacts() {
		contactsRef.observe(.childAdded, with: { snapshot in
			guard let contactID = snapshot.value as? String else {
				return
			}

			let usersRef = Database.database().reference().child("users")
			let contactQuery = usersRef.queryOrderedByKey().queryEqual(toValue: contactID)

			contactQuery.observeSingleEvent(of: .value, with: { snapshot in
				guard let contactDict = snapshot.value as? [String: Any] else {
					return
				}

				assert(contactDict.count == 1)

				for (key, value) in contactDict {
					let contact = User(id: key, properties: value as! [String: Any])
					let indexPath = IndexPath(row: self.contacts.count, section: 0)

					self.contacts.append(contact)
					self.contactsTableView.insertRows(at: [indexPath], with: .automatic)
				}
			})
		})

		contactsRef.observe(.childRemoved, with: { snapshot in
			guard let removedUID = snapshot.value as? String else {
				return
			}
			let indices = self.contacts.indices(where: { $0.uid == removedUID })
			let indexPaths = indices.map({ return IndexPath(row: $0, section: 0) })

			self.contacts.remove(at: indices)
			self.contactsTableView.deleteRows(at: indexPaths, with: .automatic)
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
			addContact(with: email)
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

	private func addContact(with email: String) {
		assert(email.isValidEmail)

		let matchingUsersRef = Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email)

		matchingUsersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let users = snapshot.value as? [String: Any] else {
				self.alertUser(title: "No User Found", message: "A user with the email '\(email)' could not be found.")

				return
			}

			assert(users.count == 1)

			for (key, value) in users {
				let user = User(id: key, properties: value as! [String: Any])

				self.contactsRef.childByAutoId().setValue(user.uid)
			}
		})
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

			let contactQuery = contactsRef.queryOrderedByValue().queryEqual(toValue: removed.uid)

			contactQuery.observeSingleEvent(of: .value, with: { snapshot in
				guard let contactDict = snapshot.value as? [String: String] else {
					return
				}

				assert(contactDict.count == 1)

				for (key, _) in contactDict {
					let contactRef = self.contactsRef.child(key)

					contactRef.removeValue()
				}
			})
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
