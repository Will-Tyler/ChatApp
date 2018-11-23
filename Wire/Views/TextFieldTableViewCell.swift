//
//  TextFieldTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 11/22/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

	private lazy var textField: UITextField = {
		let field = UITextField()

		field.delegate = self
		field.textColor = .white
		field.returnKeyType = .done

		if let currentUser = Auth.auth().currentUser {
			let displayNameRef = Database.database().reference().child("users/\(currentUser.uid)/name")

			displayNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
				let name = snapshot.value as! String

				self.textField.text = name
				self.previousValue = name
				self.textField.addTarget(self, action: #selector(self.fieldEditingEnded), for: .editingDidEnd)
			})
		}

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

	// Text field
	private var previousValue: String?

	@objc
	private func fieldEditingEnded() {
		if let text = textField.text, text.isValidDisplayName {
			if let currentUser = Auth.auth().currentUser {
				let nameRef = Database.database().reference().child("users/\(currentUser.uid)/name")

				nameRef.setValue(text, withCompletionBlock: { (error, dataRef) in
					let controller = self.controller

					guard error == nil else {
						controller?.alertUser(title: "Display Name Error", message: error!.localizedDescription)

						return
					}

					controller?.alertUser(title: "Display Name", message: "Successfully changed display name.")

					self.previousValue = text
				})
			}
		}
		else {
			textField.text = previousValue
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return resignFirstResponder()
	}

}
