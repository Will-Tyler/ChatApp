//
//  FirstViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var tableView: UITableView = {
		let table = UITableView()

		table.allowsMultipleSelection = false
		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Colors.background

		return table
	}()

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		view.addSubview(tableView)

		let safeArea = view.safeAreaLayoutGuide

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	override var title: String? {
		get {
			return "Chats"
		}
		set {}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

		setupInitialLayout()
	}

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()

		cell.backgroundColor = Colors.header

		return cell
	}

}
