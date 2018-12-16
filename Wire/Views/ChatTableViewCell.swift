//
//  ChatTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 12/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class ChatTableViewCell: UITableViewCell {

	private lazy var nameLabel: UILabel = {
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
		addSubview(nameLabel)
		addSubview(previewLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).activate()
		nameLabel.widthAnchor.constraint(equalTo: widthAnchor).activate()
		nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).activate()
		nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).activate()

		previewLabel.translatesAutoresizingMaskIntoConstraints = false
		previewLabel.heightAnchor.constraint(equalToConstant: previewLabel.intrinsicContentSize.height).activate()
		previewLabel.widthAnchor.constraint(equalTo: widthAnchor).activate()
		previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).activate()
		previewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).activate()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell

		setupInitialLayout()
	}

	override var intrinsicContentSize: CGSize {
		get {
			let superSize = super.intrinsicContentSize
			let height = nameLabel.intrinsicContentSize.height + previewLabel.intrinsicContentSize.height

			return CGSize(width: superSize.width, height: height)
		}
	}

	private var chat: Chat! {
		didSet {
			if let name = chat.name {
				nameLabel.text = name
			}
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
