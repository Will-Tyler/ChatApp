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
	private lazy var addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
	private lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
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

		navigationItem.setRightBarButton(addItem, animated: true)

		setupInitialLayout()
//		loadContacts()
		observeContacts()
	}

	private let contactsRef = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/contacts")
	private var contacts = [User]()

//	private func loadContacts() {
//		contactsRef.observeSingleEvent(of: .value, with: { (snapshot) in
//			let usersRef = Database.database().reference().child("users")
//
//			for child in snapshot.children {
//				guard let childSnapshot = child as? DataSnapshot else {
//					continue
//				}
//				let contactQuery = usersRef.queryOrderedByKey().queryEqual(toValue: childSnapshot.value)
//
//				contactQuery.observeSingleEvent(of: .value, with: { (snapshot) in
//					guard let contactDict = snapshot.value as? [String: Any] else {
//						// Couldn't find contact.
//						// Let's see if we can delete it.
//						self.contactsRef.child(childSnapshot.key).removeValue()
//
//						return
//					}
//
//					assert(contactDict.count == 1)
//
//					for (key, value) in contactDict {
//						let contact = User(id: key, properties: value as! [String: Any])
//						let indexPath = IndexPath(row: self.contacts.count, section: 0)
//
//						self.contacts.append(contact)
//						self.contactsTableView.insertRows(at: [indexPath], with: .automatic)
//					}
//				})
//			}
//		}, withCancel: { (error) in
//			self.alertUser(title: "Error Loading Contacts", message: error.localizedDescription)
//		})
//	}

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
		let constant = emailFieldHeight.constant

		emailFieldHeight.constant = constant == 0 ? emailField.intrinsicContentSize.height : 0
	}

	@objc
	private func addButtonPressed() {
		toggleEmailFieldHeight()
		emailField.becomeFirstResponder()

		navigationItem.setRightBarButton(doneItem, animated: true)
	}
	@objc
	private func doneButtonPressed() {
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
		contactsTableView.deselectRow(at: indexPath, animated: true)
	}

}
