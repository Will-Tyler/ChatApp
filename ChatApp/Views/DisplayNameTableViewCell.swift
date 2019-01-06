//
//  TextFieldTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 11/22/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


final class DisplayNameTableViewCell: TextFieldTableViewCell {

	override func layoutSubviews() {
		super.layoutSubviews()

		if let currentID = Firebase.currentID {
			Firebase.handleUser(uid: currentID, with: { user in
				self.textField.text = user.displayName
				self.previousValue = user.displayName
				self.textField.addTarget(self, action: #selector(self.fieldEditingEnded), for: .editingDidEnd)
			})
		}
	}

	// Text field
	private var previousValue: String?

	@objc
	private func fieldEditingEnded() {
		if let text = textField.text, text.isValidDisplayName {
			Firebase.updateDisplayName(to: text, completion: {
				self.controller?.alertUser(title: "Display Name", message: "Successfully changed display name.")
				self.previousValue = text
			}, error: { error in
				self.controller?.alertUser(title: "Display Name Error", message: error.localizedDescription)
			})
		}
		else {
			textField.text = previousValue
		}
	}

}
