//
//  ChatViewController.swift
//  Wire
//
//  Created by Will Tyler on 1/1/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class ChatViewController: UIViewController {

	private let chat: Chat

	init(chat: Chat) {
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented.")
	}

	private lazy var messageComposerView = MessageComposerView()
	private var messageComposerBottomConstraint: NSLayoutConstraint!

	private func setupInitialLayout() {
		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(messageComposerView)

		messageComposerView.translatesAutoresizingMaskIntoConstraints = false
		messageComposerBottomConstraint = messageComposerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
		messageComposerBottomConstraint.activate()
		messageComposerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).activate()
		messageComposerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).activate()
		messageComposerView.heightAnchor.constraint(equalToConstant: 64).activate()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background

		setupInitialLayout()

		NotificationCenter.default.addObserver(self, selector: #selector(keyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

		let tap = UITapGestureRecognizer(target: messageComposerView, action: #selector(resignFirstResponder))

		view.addGestureRecognizer(tap)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
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

}
