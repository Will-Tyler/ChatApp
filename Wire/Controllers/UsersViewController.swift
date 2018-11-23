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


class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var usersTableView: UITableView = {
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
		view.addSubview(usersTableView)

		let safeArea = view.safeAreaLayoutGuide

		usersTableView.translatesAutoresizingMaskIntoConstraints = false
		usersTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
		usersTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
		usersTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
		usersTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Users"
		view.backgroundColor = Colors.background

		setupInitialLayout()
		loadUsers()
		observeUsers()
	}

	private func loadUsers() {
		let dataRef = Database.database().reference()
		let usersRef = dataRef.child("users")

		usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let dict = snapshot.value as! [String: Any]

			for (key, value) in dict {
				let values = value as! [String: String]
				let user = User(uid: key, displayName: values["name"]!, email: values["email"]!)

				let count = self.users.count
				var insertIndex = 0

				while insertIndex < count, self.users[insertIndex].displayName < user.displayName {
					insertIndex += 1
				}

				if insertIndex < count {
					self.users.insert(user, at: insertIndex)
				}
				else {
					self.users.append(user)
				}
			}

			self.usersTableView.reloadData()
		})
	}
	private func observeUsers() {
		let dataRef = Database.database().reference()
		let usersRef = dataRef.child("users")

		usersRef.observe(.childChanged, with: { (snapshot) in
			print(snapshot.key)

			let updatedUID = snapshot.key
			let index = self.users.firstIndex(where: { $0.uid == updatedUID })!
			let values = snapshot.value as! [String: String]
			var user = self.users[index]

			user.displayName = values["name"]!
			self.users.replace(at: index, with: user)

			let path = IndexPath(row: index, section: 0)

			self.usersTableView.reloadRows(at: [path], with: .automatic)
		})
	}

	private var users = [User]()

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.cellID, for: indexPath) as! UsersTableViewCell
		let user = users[indexPath.row]

		cell.backgroundColor = Colors.header
		cell.textLabel!.text = user.displayName
		cell.textLabel!.textColor = .white

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		usersTableView.deselectRow(at: indexPath, animated: true)
	}

}
