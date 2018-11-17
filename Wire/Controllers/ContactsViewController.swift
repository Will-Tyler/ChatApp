//
//  ContactsViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var contactsTableView: UITableView = {
		let table = UITableView()

		table.allowsMultipleSelection = false
		table.delegate = self
		table.dataSource = self

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

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Contacts"
		view.backgroundColor = Colors.background
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

		setupInitialLayout()
	}

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}

}
