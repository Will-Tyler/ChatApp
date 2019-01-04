//
//  SecondViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let signOutDelegate: SettingsViewControllerSignOutDelegate

	init(signOutDelegate: SettingsViewControllerSignOutDelegate) {
		self.signOutDelegate = signOutDelegate
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private lazy var tableView: UITableView = {
		let table = UITableView(frame: view.frame, style: .grouped)

		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Colors.background

		return table
	}()

	private func setupInitialLayout() {
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
				Firebase.signOut(completion: {
					self.signOutDelegate.didSignOut()
				}, error: { error in
					self.alertUser(title: "Error Signing Out", message: error.localizedDescription)
				})
			}
		]
	]

	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionNames.count
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionNames[section]!
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellActions[section]!.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0, indexPath.row == 0 {
			return DisplayNameTableViewCell()
		}
		else {
			let cell = DarkTableViewCell()

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


protocol SettingsViewControllerSignOutDelegate {

	func didSignOut()

}
