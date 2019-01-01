//
//  ChatTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 12/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class ChatTableViewCell: UITableViewCell {

	private lazy var titleLabel: UILabel = {
		let label = UILabel()

		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 24)

		return label
	}()
	private lazy var previewLabel: UILabel = {
		let label = UILabel()

		label.textColor = .white

		return label
	}()

	private func setupInitialLayout() {
		addSubview(titleLabel)
		addSubview(previewLabel)

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.heightAnchor.constraint(equalToConstant: 28).activate()
		titleLabel.widthAnchor.constraint(equalTo: widthAnchor).activate()
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).activate()
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).activate()

		previewLabel.translatesAutoresizingMaskIntoConstraints = false
		previewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).activate()
		previewLabel.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
		previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).activate()
		previewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).activate()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell

		setupInitialLayout()
	}

	private var chat: Chat! {
		didSet {
			chat.handleTitle(with: { title in
				self.titleLabel.text = title
			})

			if let preview = chat.preview {
				previewLabel.text = preview
			}
		}
	}
	func setChat(to chat: Chat) {
		self.chat = chat
	}

	static let cellID = "ChatTableViewCell"

}
