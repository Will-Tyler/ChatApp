//
//  Firebase.swift
//  Wire
//
//  Created by Will Tyler on 12/31/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation
import Firebase


final class Firebase {

	static var currentID: String? {
		get {
			return Auth.auth().currentUser?.uid
		}
	}
	static var isSignedIn: Bool {
		get {
			return Auth.auth().currentUser != nil
		}
	}

	@discardableResult
	static func createChat(name: String?, memberIDs: [String]) -> Chat {
		let chatsRef = Database.database().reference(withPath: "chats")
		let chatRef = chatsRef.childByAutoId()
		var uids = memberIDs

		uids.append(currentID!)
		
		var dict: [String: Any] = [
			"members": uids
		]

		if let name = name {
			dict["name"] = name
		}

		chatRef.updateChildValues(dict)

		uids.forEach({ uid in
			add(chatID: chatRef.key, to: uid)
		})

		let chatID = chatRef.key
		let chat = Chat(id: chatID, name: name, memberIDs: memberIDs)

		return chat
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
			assert(id == snapshot.key)
			
			let values = snapshot.value as! [String: Any]
			let chat = Chat(id: id, from: values)

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

	static func observeContacts(with handler: @escaping (User)->()) {
		let contactsRef = Database.database().reference(withPath: "users/\(currentID!)/contacts")

		contactsRef.observe(.childAdded, with: { snapshot in
			if let contactID = snapshot.value as? String {
				handleUser(uid: contactID, with: handler)
			}
		})
	}

	static func handleContactRemoved(with handler: @escaping (User)->()) {
		let contactsRef = Database.database().reference(withPath: "users/\(currentID!)/contacts")

		contactsRef.observe(.childRemoved, with: { snapshot in
			if let contactID = snapshot.value as? String {
				handleUser(uid: contactID, with: handler)
			}
		})
	}

	static func addContact(email: String, failHandler: @escaping ()->()) {
		assert(email.isValidEmail)

		let contactsRef = Database.database().reference(withPath: "users/\(currentID!)/contacts")
		let matchingUsersRef = Database.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: email)

		matchingUsersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let users = snapshot.value as? [String: Any] else {
				failHandler()
				return
			}

			assert(users.count == 1)

			for (key, value) in users {
				let user = User(id: key, properties: value as! [String: Any])

				contactsRef.childByAutoId().setValue(user.uid)
			}
		})
	}

	static func removeContact(contact: User) {
		let contactsRef = Database.database().reference(withPath: "users/\(currentID!)/contacts")
		let contactQuery = contactsRef.queryOrderedByValue().queryEqual(toValue: contact.uid)

		contactQuery.observeSingleEvent(of: .value, with: { snapshot in
			guard let contactDict = snapshot.value as? [String: String] else {
				return
			}

			assert(contactDict.count == 1)

			for (key, _) in contactDict {
				let contactRef = contactsRef.child(key)

				contactRef.removeValue()
			}
		})
	}

	static func signIn(email: String, password: String, completion handler: @escaping (Error?)->()) {
		Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
			handler(error)
		}
	}
	static func signOut(completion: ()->(), error handler: (Error)->()) {
		do {
			try Auth.auth().signOut()
			completion()
		}
		catch let error {
			handler(error)
			return
		}
	}

	static func createUser(email: String, password: String, displayName: String, completion: @escaping ()->(), error errorHandler: @escaping (Error)->()) {
		Auth.auth().createUser(withEmail: email, password: password, completion: { (authDataResult, error) in
			guard error == nil else {
				errorHandler(error!)
				return
			}

			let authData = authDataResult!
			let user = authData.user
			let dataRef = Database.database().reference()
			let usersRef = dataRef.child("users")
			let userRef = usersRef.child(user.uid)

			userRef.updateChildValues(["name": displayName, "email": email])
			completion()
		})
	}

	static func updateDisplayName(to name: String, completion: @escaping ()->(), error errorHandler: @escaping (Error)->()) {
		if let currentID = currentID {
			let nameRef = Database.database().reference().child("users/\(currentID)/name")

			nameRef.setValue(name, withCompletionBlock: { (error, dataRef) in
				guard error == nil else {
					errorHandler(error!)
					return
				}

				completion()
			})
		}
	}

	static func leave(chat: Chat) {
		let membersRef = Database.database().reference(withPath: "chats/\(chat.id)/members")
		let chatsRef = Database.database().reference(withPath: "users/\(currentID!)/chats")

		membersRef.observeSingleEvent(of: .value, with: { snapshot in
			let memberIDs = snapshot.value as! [String]
			let indices = memberIDs.indices(where: { $0 == currentID! })

			for index in indices {
				let memberRef = membersRef.child("\(index)")

				memberRef.removeValue()
			}
		})
		chatsRef.observeSingleEvent(of: .value, with: { snapshot in
			let chatPointers = snapshot.value as! [String: String]
			let keys = chatPointers.keys(where: { $1 == chat.id })

			for key in keys {
				let chatPointer = chatsRef.child(key)

				chatPointer.removeValue()
			}
		})
	}

	static func send(message: Message, to chat: Chat) {
		let transcriptRef = Database.database().reference(withPath: "chats/\(chat.id)/transcript")
		let messageRef = transcriptRef.childByAutoId()
		let dict: [String: Any] = [
			"content": message.content,
			"time": Int64(message.timestamp.timeIntervalSince1970),
			"sender": message.senderID
		]

		messageRef.setValue(dict)
	}

	static func observeTranscript(of chat: Chat, with handler: @escaping (Message)->()) {
		let transcriptRef = Database.database().reference(withPath: "chats/\(chat.id)/transcript")

		transcriptRef.observe(.childAdded, with: { snapshot in
			let messageDict = snapshot.value as! [String: Any]
			let message = Message(dict: messageDict)

			handler(message)
		})
	}

	static func handlePreview(of chat: Chat, with handler: @escaping (String)->()) {
		let transcriptRef = Database.database().reference(withPath: "chats/\(chat.id)/transcript")
		let query = transcriptRef.queryOrderedByKey().queryLimited(toLast: 1)

		query.observeSingleEvent(of: .value, with: { snapshot in
			if let message = snapshot.value as? [String: Any] {
				assert(message.count == 1)

				let messageDict = message.first!.value as! [String: Any]
				let content = messageDict["content"] as! String

				handler(content)
			}
		})
	}

}
