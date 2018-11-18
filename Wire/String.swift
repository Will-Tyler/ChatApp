//
//  String.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension String {

	var isValidEmail: Bool {
		get {
			let pattern = "\\A(?=[a-z0-9@.!#$%&'*+/=?^_`{|}~-]{6,254}\\z)(?=[a-z0-9.!#$%&'*+/=?^_`{|}~-]{1,64}@)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:(?=[a-z0-9-]{1,63}\\.)[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+(?=[a-z0-9-]{1,63}\\z)[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z"
			let regex = try! NSRegularExpression(pattern: pattern, options: [])

			return regex.numberOfMatches(in: self, range: NSRange(location: 0, length: count)) > 0
		}
	}

	// Min: 8 characters
	// Max: 16 characters
	// At least one uppercase
	// At least one lowercase
	// At least one digit
	// No symbols
	var isValidPassword: Bool {
		get {
			let pattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{8,16}$"
			let regex = try! NSRegularExpression(pattern: pattern, options: [])

			return regex.numberOfMatches(in: self, range: NSRange(location: 0, length: count)) > 0
		}
	}

	var isValidDisplayName: Bool {
		get {
			let pattern = "^[A-Z][a-z]{2,15} [A-Z][a-z]{2,15}$"
			let regex = try! NSRegularExpression(pattern: pattern, options: [])

			return regex.numberOfMatches(in: self, range: NSRange(location: 0, length: count)) > 0
		}
	}

}
