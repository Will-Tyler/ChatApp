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

	private var name: String?
	var members: Set<Member>
	var transcript: [Message]

	init(name: String? = nil, members: Set<Member>, transcript: [Message] = []) {
		assert(!members.isEmpty, "Cannot have a Chat without any members.")

		if let name = name {
			assert(!name.isEmpty, "Cannot have a Chat with an empty name.")
		}

		self.name = name
		self.members = members
		self.transcript = transcript
	}

	var preview: String? {
		get {
			return transcript.last?.content
		}
	}
	var title: String {
		get {
			if name != nil {
				return name!
			}
			else {
				var names = [String]()

				assert(!self.members.isEmpty)

				var members = self.members

				while members.count > 0, names.count < 3 {
					let random = members.randomElement()!

					names.append(random.displayName)
					members.remove(random)
				}

				return names.joined(separator: ", ").appending("...")
			}
		}
	}
	
}


var fakeData: [Chat] {
	get {
		let members: [User] = [
			User(id: "0", properties: ["email": "none", "name": "Will"]),
			User(id: "1", properties: ["email": "none", "name": "Larry"])
		]
		let messages: [Message] = [
			Message(content: "Hello", timestamp: Date(), sender: members.first!)
		]
		let data = [
			Chat(name: "Students", members: Set<User>(members), transcript: messages),
			Chat(members: Set<User>(members))
		]

		return data
	}
}
