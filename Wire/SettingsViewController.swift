//
//  SecondViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var tableView: UITableView = {
		let table = UITableView(frame: view.frame, style: .grouped)

		table.delegate = self
		table.dataSource = self
		table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellID)

		return table
	}()

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(tableView)

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Settings"
		tabBarItem.title = title!

		view.backgroundColor = .white

		setupInitialLayout()
	}

	// TableView
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let names = [
			0: "Configure Wire"
		]

		return names[section]
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellID) as! SettingsTableViewCell

		cell.textLabel!.text = "Sign Out"

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alert = UIAlertController(title: "Sign Out", message: "Sign Out has not been implemented.", preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

		present(alert, animated: true, completion: nil)
	}

}
