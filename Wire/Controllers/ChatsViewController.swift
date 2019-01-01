//
//  FirstViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase


final class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private lazy var tableView: UITableView = {
		let table = UITableView()

		table.allowsMultipleSelection = false
		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Colors.background
		table.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.cellID)

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

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemAction))

		setupInitialLayout()
		observeChats()
	}

	@objc
	private func addItemAction() {
		navigationController?.pushViewController(NewChatViewController(), animated: true)
	}

	private var chats = [Chat]()

	private func observeChats() {
		Firebase.observeChats(at: Auth.auth().currentUser!.uid, with: { chat in
			let count = self.chats.count
			let path = IndexPath(row: count, section: 0)

			self.chats.append(chat)
			self.tableView.insertRows(at: [path], with: .automatic)
		})
	}

	// Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chats.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellID, for: indexPath) as! ChatTableViewCell

		cell.setChat(to: chats[indexPath.row])

		return cell
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 96
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
