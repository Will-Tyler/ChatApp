//
//  Chat.swift
//  Wire
//
//  Created by Will Tyler on 12/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


struct Chat {

	typealias Member = User

	var name: String?
	var members: Set<Member>
	var transcript: [Message]

	init(name: String? = nil, members: Set<Member>, transcript: [Message] = []) {
		assert(!members.isEmpty, "Cannot have a Chat without any members.")

		self.name = name
		self.members = members
		self.transcript = transcript
	}

	var preview: String? {
		get {
			return transcript.last?.content
		}
	}
	
}


var fakeData: [Chat] {
	get {
		let members: [User] = [
			User(id: "0", properties: ["email": "none", "name": "Will"])
		]
		let messages: [Message] = [
			Message(content: "Hello", timestamp: Date(), sender: members.first!)
		]
		let data = [
			Chat(name: "Students", members: Set<User>(members), transcript: messages),
		]

		return data
	}
}
