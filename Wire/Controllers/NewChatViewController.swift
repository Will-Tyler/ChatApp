//
//  NewChatViewController.swift
//  Wire
//
//  Created by Will Tyler on 12/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class NewChatViewController: UITableViewController {

	private lazy var createItem: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createItemAction))

		item.isEnabled = false

		return item
	}()
	private lazy var contactsViewController = ContactsViewController()

	override func loadView() {
		super.loadView()
		
		view = UITableView(frame: view.frame, style: .grouped)

		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = Colors.background
		tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.cellID)
		tableView.register(DarkTableViewCell.self, forCellReuseIdentifier: DarkTableViewCell.cellID)
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background
		navigationItem.setRightBarButton(createItem, animated: true)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	override var title: String? {
		get {
			return "Create Chat"
		}
		set {}
	}

	@objc
	private func createItemAction() {
	}

	private var selectedContacts: [User] {
		get {
			return contactsViewController.selectedContacts
		}
	}

	// Table view
	private let sectionNames = [
		0: "Name",
		1: "Members"
	]
	private lazy var cellActions = [
		1: [
			0: {
				self.navigationController!.pushViewController(self.contactsViewController, animated: true)
			}
		]
	]
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sectionNames.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionNames[section]!
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return selectedContacts.count + 1

		default: fatalError()
		}
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			return tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.cellID, for: indexPath) as! TextFieldTableViewCell

		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: DarkTableViewCell.cellID, for: indexPath) as! DarkTableViewCell

			cell.textLabel?.text = "Add Members"
			cell.textLabel?.textColor = .white

			return cell

		default: fatalError()
		}
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		cellActions[indexPath.section]![indexPath.row]!()
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
