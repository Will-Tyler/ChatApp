//
//  Chat.swift
//  Wire
//
//  Created by Will Tyler on 12/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


class Chat {

	typealias Member = User

	var name: String?
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
	init(from dictionary: [String: Any]) {
		let memberUIDs = dictionary["members"] as! [String]

		self.members = []
		self.transcript = []
		self.name = dictionary["name"] as? String

		memberUIDs.forEach({ uid in
			Firebase.handleUser(uid: uid, with: { user in
				self.members.insert(user)
			})
		})
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
