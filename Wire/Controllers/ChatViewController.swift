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

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

}
