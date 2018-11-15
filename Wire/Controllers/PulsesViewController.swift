//
//  FirstViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class PulsesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var tableView: UITableView = {
		let table = UITableView()

		table.delegate = self
		table.dataSource = self

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

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Pulses"

		view.backgroundColor = .white

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: nil)

		setupInitialLayout()
	}

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}

}
