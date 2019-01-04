//
//  MessageCollectionViewCell.swift
//  Wire
//
//  Created by Will Tyler on 1/2/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class MessageCollectionViewCell: UICollectionViewCell {

	private lazy var textView: UITextView = {
		let view = UITextView()

		switch mode! {
		case .me:
			view.backgroundColor = Colors.systemBlue

		case .other:
			view.backgroundColor = .darkGray
		}

		view.font = UIFont.systemFont(ofSize: 18)
		view.textColor = .white
		view.isEditable = false
		view.isScrollEnabled = false
		view.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

		view.layer.masksToBounds = false
		view.layer.cornerRadius = 8

		return view
	}()

	private func setupInitialLayout() {
		addSubview(textView)

		let bounds = CGSize(width: 256 as CGFloat, height: .greatestFiniteMagnitude)
		let textViewSize = textView.sizeThatFits(bounds)

		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.heightAnchor.constraint(equalToConstant: textViewSize.height).activate()
		textView.widthAnchor.constraint(equalToConstant: textViewSize.width).activate()
		textView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()

		switch mode! {
		case .me:
			textView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()

		case .other:
			textView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
		}
	}

//	override func layoutSubviews() {
//		super.layoutSubviews()
//
//		backgroundColor = Colors.cell
//	}

	static let cellID = "MessageCollectionViewCell"

	private var message: Message! {
		didSet {
			textView.text = message.content
			setupInitialLayout()
		}
	}

	private var mode: Mode! {
		get {
			if message.senderID == Firebase.currentID! {
				return .me
			}
			else {
				return .other
			}
		}
	}

	func set(message: Message) {
		self.message = message
	}

}


fileprivate enum Mode {

	case me
	case other

}
