//
//  SecondViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import GoogleSignIn


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

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Settings"
		tabBarItem.title = title!

		view.backgroundColor = Colors.background

		setupInitialLayout()
	}

	// TableView
	private let names = [
		0: "Configure Wire"
	]
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return names[section]!
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	private let texts = [
		0: [
			0: "Disconnect Google",
			1: "Sign Out"
		]
	]
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SettingsTableViewCell()

		cell.textLabel!.text = texts[indexPath.section]![indexPath.row]!
		cell.textLabel!.textColor = .red
		cell.backgroundColor = Colors.header

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let tbc = tabBarController! as! TabBarController

		switch indexPath.row {
		case 0:
			GIDSignIn.sharedInstance()!.disconnect()
			tbc.presentSignInController(animated: true)

		case 1:
			GIDSignIn.sharedInstance()!.signOut()
			tbc.presentSignInController(animated: true)

		default: fatalError()
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}

}
