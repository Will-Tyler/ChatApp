//
//  MessageComposerView.swift
//  Wire
//
//  Created by Will Tyler on 1/2/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class MessageComposerView: UIView {

	private let delegate: MessageComposerViewDelegate

	init(delegate: MessageComposerViewDelegate) {
		self.delegate = delegate
		super.init(frame: CGRect())
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private lazy var textField: UITextField = {
		let field = UITextField()

		field.attributedPlaceholder = NSAttributedString(string: "Compose a message...", attributes: [.foregroundColor: UIColor.lightGray])
		field.textColor = .white

		return field
	}()
	private lazy var sendButton: UIButton = {
		let button = UIButton(type: .system)

		button.setTitle("Send", for: .normal)
		button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)

		return button
	}()

	private func setupInitialLayout() {
		addSubview(sendButton)
		addSubview(textField)

		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.heightAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.height).activate()
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).activate()
		sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).activate()
		sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).activate()

		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.heightAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.height).activate()
		textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).activate()
		textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).activate()
		textField.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.masksToBounds = false
		layer.borderColor = Colors.cell.cgColor
		layer.borderWidth = 1

		setupInitialLayout()
	}
	override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}
	override func resignFirstResponder() -> Bool {
		return textField.resignFirstResponder()
	}

	override var intrinsicContentSize: CGSize {
		get {
			let superSize = super.intrinsicContentSize
			let height = sendButton.intrinsicContentSize.height + 16

			return CGSize(width: superSize.width, height: height)
		}
	}

	@objc
	private func sendButtonAction() {
		if let content = textField.text, !content.isEmpty {
			let message = Message(content: content, senderID: Firebase.currentID!)

			delegate.didCompose(message: message)
			textField.text = ""
		}
	}

}

protocol MessageComposerViewDelegate {

	func didCompose(message: Message)

}
