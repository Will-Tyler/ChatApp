//
//  MessageComposerView.swift
//  Wire
//
//  Created by Will Tyler on 1/2/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class MessageComposerView: UIView {

	private lazy var textField: UITextField = {
		let field = UITextField()

		field.textColor = .white
		field.layer.masksToBounds = false
		field.layer.borderColor = Colors.cell.cgColor
		field.layer.borderWidth = 1

		return field
	}()

	private func setupInitialLayout() {
		addSubview(textField)

		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.heightAnchor.constraint(equalToConstant: textField.intrinsicContentSize.height).activate()
		textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).activate()
		textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).activate()
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

}
