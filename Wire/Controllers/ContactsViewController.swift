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

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })
		view.addSubview(contactsTableView)

		let safeArea = view.safeAreaLayoutGuide

		contactsTableView.translatesAutoresizingMaskIntoConstraints = false
		contactsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
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

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

		setupInitialLayout()
		loadContacts()
	}

	private var contacts = [User]()

	private func loadContacts() {
		guard let uid = Auth.auth().currentUser?.uid else {
			return
		}

		let dataRef = Database.database().reference()
		let contactsRef = dataRef.child("users/\(uid)/contacts")

		contactsRef.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let contactIDs = snapshot.value as? [String] else {
				// User probably doesn't have any contacts yet.
				return
			}

			for contactID in contactIDs {
				let contactRef = dataRef.child("users/\(contactID)")

				contactRef.observeSingleEvent(of: .value, with: { (snapshot) in
					let properties = snapshot.value as! [String: Any]
					let contact = User(id: contactID, properties: properties)

					self.contacts.append(contact)
					self.contactsTableView.reloadData()
				}, withCancel: { (error) in
					print(error.localizedDescription)
				})
			}
		}, withCancel: { (error) in
			self.alertUser(title: "Error Loading Contacts", message: error.localizedDescription)
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
