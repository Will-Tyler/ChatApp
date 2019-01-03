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

	let id: String
	var name: String?
	var memberIDs: [Member.UID]
	var transcript: [Message]
	private let loadedTitle: NSMutableString

	init(id: String, name: String? = nil, memberIDs: [String], transcript: [Message] = []) {
		assert(!id.isEmpty)
		assert(!memberIDs.isEmpty, "Cannot have a Chat without any members.")

		if let name = name {
			assert(!name.isEmpty, "Cannot have a Chat with an empty name.")
		}

		self.id = id
		self.name = name
		self.memberIDs = memberIDs
		self.transcript = transcript
		self.loadedTitle = ""
	}
	init(id: String, from dictionary: [String: Any]) {
		self.id = id
		self.memberIDs = dictionary["members"] as! [String]
		self.name = dictionary["name"] as? String
		self.transcript = dictionary["transcript"] as? [Message] ?? []
		self.loadedTitle = ""
	}

	var preview: String? {
		get {
			return transcript.last?.content
		}
	}
	func handleTitle(with handler: @escaping (String)->()) {
		if name != nil {
			handler(name!)
		}
		else if !(loadedTitle.length == 0) {
			handler(loadedTitle as String)
		}
		else {
			var memberIDs = Set<User.UID>(self.memberIDs)
			var randomIDs = [String]()

			if let currentID = Firebase.currentID {
				memberIDs.remove(currentID)
			}

			while memberIDs.count > 0, randomIDs.count < 3 {
				let randomID = memberIDs.randomElement()!

				memberIDs.remove(randomID)
				randomIDs.append(randomID)
			}

			var names = [String]()
			let group = DispatchGroup()

			for randomID in randomIDs {
				group.enter()
				Firebase.handleUser(uid: randomID, with: { user in
					names.append(user.displayName)
					group.leave()
				})
			}

			group.notify(queue: .main, execute: {
				assert(!names.isEmpty)

				let title: String

				if names.count > 1 {
					title = names.joined(separator: ", ").appending("...")
				}
				else {
					title = names.first!
				}

				self.loadedTitle.setString(title)
				handler(title)
			})
		}
	}

	mutating func send(message: Message) {
		transcript.append(message)
		Firebase.send(message: message, to: self)
	}
	
}
