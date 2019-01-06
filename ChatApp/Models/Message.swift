//
//  Message.swift
//  Wire
//
//  Created by Will Tyler on 12/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


struct Message {

	let content: String
	let timestamp: Date
	let senderID: User.UID

	init(content: String, senderID: User.UID) {
		assert(!content.isEmpty)
		assert(!senderID.isEmpty)

		self.content = content
		self.timestamp = Date()
		self.senderID = senderID
	}
	init(dict: [String: Any]) {
		let dateInt = dict["time"] as! Int64

		self.timestamp = Date(timeIntervalSince1970: TimeInterval(exactly: dateInt)!)
		self.content = dict["content"] as! String
		self.senderID = dict["sender"] as! String
	}

}
