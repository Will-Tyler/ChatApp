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


final class DisplayNameTableViewCell: TextFieldTableViewCell {

	override func layoutSubviews() {
		super.layoutSubviews()

		if let currentUser = Auth.auth().currentUser {
			let displayNameRef = Database.database().reference().child("users/\(currentUser.uid)/name")

			displayNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
				let name = snapshot.value as! String

				self.textField.text = name
				self.previousValue = name
				self.textField.addTarget(self, action: #selector(self.fieldEditingEnded), for: .editingDidEnd)
			})
		}
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

}
