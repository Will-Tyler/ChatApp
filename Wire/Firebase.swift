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

	static var currentID: String? {
		get {
			return Auth.auth().currentUser?.uid
		}
	}

	static func create(chat: Chat) {
		let chatsRef = Database.database().reference(withPath: "chats")
		let chatRef = chatsRef.childByAutoId()
		var uids = chat.memberIDs

		uids.append(Auth.auth().currentUser!.uid)
		
		var dict: [String: Any] = [
			"members": uids
		]

		if let name = chat.name {
			dict["name"] = name
		}

		chatRef.updateChildValues(dict)

		uids.forEach({ uid in
			add(chatID: chatRef.key, to: uid)
		})
	}

	private static func add(chatID: String, to uid: User.UID) {
		let userChatsRef = Database.database().reference(withPath: "users/\(uid)/chats")
		let userChatRef = userChatsRef.childByAutoId()

		userChatRef.setValue(chatID)
	}

	static func observeChats(eventType: DataEventType, with handler: @escaping (DataSnapshot)->()) {
		let chatsRef = Database.database().reference(withPath: "chats")

		chatsRef.observe(eventType, with: handler)
	}

	static func handleUser(uid: User.UID, with handler: @escaping (User)->()) {
		let userRef = Database.database().reference(withPath: "users/\(uid)")

		userRef.observeSingleEvent(of: .value, with: { snapshot in
			assert(uid == snapshot.key)

			let properties = snapshot.value as! [String: Any]
			let user = User(id: uid, properties: properties)

			handler(user)
		})
	}

	private static func handleChat(at id: String, with handler: @escaping (Chat)->()) {
		let chatRef = Database.database().reference(withPath: "chats/\(id)")

		chatRef.observeSingleEvent(of: .value, with: { snapshot in
			let values = snapshot.value as! [String: Any]
			let chat = Chat(from: values)

			handler(chat)
		})
	}

	static func observeChats(at uid: User.UID, with handler: @escaping (Chat)->()) {
		let userChatsRef = Database.database().reference(withPath: "users/\(uid)/chats")

		userChatsRef.observe(.childAdded, with: { snapshot in
			let chatID = snapshot.value as! String

			handleChat(at: chatID, with: handler)
		})
	}

}
