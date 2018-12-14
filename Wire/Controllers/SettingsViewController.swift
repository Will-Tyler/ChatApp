//
//  SecondViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var tableView: UITableView = {
		let table = UITableView(frame: view.frame, style: .grouped)

		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Colors.background

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

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	override var title: String? {
		get {
			return "Settings"
		}
		set {}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background

		setupInitialLayout()
	}

	// TableView
	private let sectionNames = [
		0: "Display Name",
		1: "Configure Wire"
	]
	private let cellTexts = [
		0: [
			0: "" // Display name cell
		],
		1: [
			0: "Sign Out"
		]
	]
	private lazy var cellActions = [
		0: [
			0: {}
		],
		1: [
			0: {
				let tbc = self.tabBarController! as! TabBarController

				do {
					try Auth.auth().signOut()
				}
				catch let error {
					self.alertUser(title: "Error Signing Out", message: error.localizedDescription)
				}

				tbc.presentSignInController(animated: true)
			}
		]
	]

	func numberOfSections(in tableView: UITableView) -> Int {
		if tableView === self.tableView {
			return 2
		}
		else {
			fatalError()
		}
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionNames[section]!
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellTexts[section]!.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0, indexPath.row == 0 {
			return TextFieldTableViewCell()
		}
		else {
			let cell = SettingsTableViewCell()

			cell.textLabel!.text = cellTexts[indexPath.section]![indexPath.row]!
			cell.textLabel!.textColor = .red

			return cell
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		cellActions[indexPath.section]![indexPath.row]!()

		tableView.deselectRow(at: indexPath, animated: true)
	}

}
