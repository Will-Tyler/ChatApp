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

		return names[section]!
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SettingsTableViewCell()

		cell.textLabel!.text = "Sign Out"

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let actions = [
			0: {
				let firebaseAuth = Auth.auth()

				do {
					try firebaseAuth.signOut()

					let alert = UIAlertController(title: "Success", message: "Sign out successful.", preferredStyle: .alert)

					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

					self.present(alert, animated: true, completion: nil)
				}
				catch {
					let alert = UIAlertController(title: "Failure", message: "Error signing out: \(error)", preferredStyle: .alert)

					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

					self.present(alert, animated: true, completion: nil)
				}
			}
		]

		actions[indexPath.row]!()
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
