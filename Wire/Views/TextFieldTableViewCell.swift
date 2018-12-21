//
//  TextFieldTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 12/21/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

	lazy var textField: UITextField = {
		let field = UITextField()

		field.delegate = self
		field.textColor = .white
		field.returnKeyType = .done

		return field
	}()

	private func setupInitialLayout() {
		addSubview(textField)

		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).activate()
		textField.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
		textField.topAnchor.constraint(equalTo: topAnchor).activate()
		textField.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell

		setupInitialLayout()
	}
	override func resignFirstResponder() -> Bool {
		return textField.resignFirstResponder()
	}

	static let cellID = "TextFieldTableViewCell"

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return resignFirstResponder()
	}
	
}
