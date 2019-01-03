//
//  ChatViewController.swift
//  Wire
//
//  Created by Will Tyler on 1/1/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class ChatViewController: UIViewController, MessageComposerViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

	private var chat: Chat

	init(chat: Chat) {
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented.")
	}

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)

		collection.backgroundColor = Colors.background
		collection.allowsSelection = false
		collection.delegate = self
		collection.dataSource = self
		collection.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: MessageCollectionViewCell.cellID)

		return collection
	}()
	private lazy var messageComposerView = MessageComposerView(delegate: self)
	private var messageComposerBottomConstraint: NSLayoutConstraint!

	private func setupInitialLayout() {
		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(messageComposerView)
		view.addSubview(collectionView)

		messageComposerView.translatesAutoresizingMaskIntoConstraints = false
		messageComposerBottomConstraint = messageComposerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
		messageComposerBottomConstraint.activate()
		messageComposerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).activate()
		messageComposerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).activate()
		messageComposerView.heightAnchor.constraint(equalToConstant: messageComposerView.intrinsicContentSize.height).activate()

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).activate()
		collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).activate()
		collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).activate()
		collectionView.bottomAnchor.constraint(equalTo: messageComposerView.topAnchor).activate()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background
		tabBarController?.tabBar.isHidden = true

		setupInitialLayout()

		NotificationCenter.default.addObserver(self, selector: #selector(keyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

		let tap = UITapGestureRecognizer(target: messageComposerView, action: #selector(resignFirstResponder))

		view.addGestureRecognizer(tap)

		observeTranscript()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	override var title: String? {
		get {
			return chat.title
		}
		set {}
	}

	@objc
	private func keyboard(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
			let y = endFrame.origin.y
			let distanceFromBottom = UIScreen.main.bounds.height - y
			var newConstant = -distanceFromBottom

			if newConstant < 0 {
				newConstant += view.safeAreaInsets.bottom
			}

			messageComposerBottomConstraint.constant = newConstant
		}
	}

	private func observeTranscript() {
		Firebase.observeTranscript(of: chat, with: { message in
			self.append(message: message)
		})
	}

	// MessageComposerViewDelegate
	func didCompose(message: Message) {
		chat.send(message: message)
	}

	private var messages = [Message]()

	func append(message: Message) {
		let count = messages.count
		let path = IndexPath(row: count, section: 0)

		messages.append(message)
		collectionView.insertItems(at: [path])
	}

	// Collection view
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let messageCell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCollectionViewCell.cellID, for: indexPath) as! MessageCollectionViewCell

		messageCell.set(message: messages[indexPath.row])

		return messageCell
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let content = messages[indexPath.row].content as NSString
		let width: CGFloat = collectionView.bounds.width
		let size = CGSize(width: 256 as CGFloat, height: .greatestFiniteMagnitude)
		let font = UIFont.systemFont(ofSize: 18)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let estimatedFrame = content.boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
		let height = ceil(estimatedFrame.height)

		return CGSize(width: width, height: height + 16)
	}

}
