//
//  AddContactView.swift
//  Wire
//
//  Created by Will Tyler on 12/14/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class AddContactView: UIView {

	private lazy var emailField: UITextField = {
		let field = UITextField()

		field.placeholder = "Enter an email address."
		field.keyboardType = .emailAddress
		field.backgroundColor = .white
		field.layer.masksToBounds = false
		field.layer.cornerRadius = 8

		return field
	}()

	private func setupInitialLayout() {
		addSubview(emailField)

		emailField.translatesAutoresizingMaskIntoConstraints = false
		emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).activate()
		emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).activate()
		emailField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).activate()
		emailField.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = .gray

		setupInitialLayout()
	}
	@discardableResult
	override func becomeFirstResponder() -> Bool {
		return emailField.becomeFirstResponder()
	}
	@discardableResult
	override func resignFirstResponder() -> Bool {
		return emailField.resignFirstResponder()
	}

	override var intrinsicContentSize: CGSize {
		get {
			let fieldSize = emailField.intrinsicContentSize

			return CGSize(width: fieldSize.width + 16, height: fieldSize.height + 16)
		}
	}

	var email: String? {
		get {
			if let text = emailField.text, text.isValidEmail {
				return text
			}
			else {
				return nil
			}
		}
	}

}
