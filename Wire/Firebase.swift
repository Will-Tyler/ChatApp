//
//  Firebase.swift
//  Wire
//
//  Created by Will Tyler on 12/31/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


final class Firebase {

	static func add(chat: Chat) {
		let chatsRef = Database.database().reference(withPath: "chats")
		let chatRef = chatsRef.childByAutoId()
		var dict: [String: Any] = [
			"members": chat.members.map({ return $0.uid })
		]

		if let name = chat.name {
			dict["name"] = name
		}

		chatRef.updateChildValues(dict)
	}

	static func observeChats(eventType: DataEventType, with handler: @escaping (DataSnapshot)->()) {
		let chatsRef = Database.database().reference(withPath: "chats")

		chatsRef.observe(eventType, with: handler)
	}

	static func handleUser(uid: User.UID, with handler: @escaping (User)->()) {
		let usersRef = Database.database().reference(withPath: "users")
		let query = usersRef.queryOrderedByKey().queryEqual(toValue: uid)

		query.observeSingleEvent(of: .value, with: { snapshot in
			assert(uid == snapshot.key)

			let properties = snapshot.value as! [String: Any]
			let user = User(id: uid, properties: properties)

			handler(user)
		})
	}

}
