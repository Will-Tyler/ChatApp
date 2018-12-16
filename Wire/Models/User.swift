//
//  User.swift
//  Wire
//
//  Created by Will Tyler on 11/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


struct User: Hashable {

	let uid: String
	var displayName: String
	let email: String

	init(id: String, properties: [String: Any]) {
		self.uid = id
		self.displayName = properties["name"] as! String
		self.email = properties["email"] as! String
	}
	
}
