//
//  TabBarController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController, SignInViewControllerDelegate, SettingsViewControllerSignOutDelegate {

	private lazy var signInController = SignInViewController(delegate: self)
	private var chatsNavigation: DarkNavigationContoller {
		get {
			return DarkNavigationContoller(rootViewController: ChatsViewController())
		}
	}
	private var contactsNavigation: DarkNavigationContoller {
		get {
			return DarkNavigationContoller(rootViewController: ContactsViewController())
		}
	}
	private var settingsNavigation: DarkNavigationContoller  {
		get {
			let controller = DarkNavigationContoller(rootViewController: SettingsViewController(signOutDelegate: self))

			controller.navigationBar.prefersLargeTitles = true

			return controller
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		if Firebase.isSignedIn {
			didSignIn()
		}
		else {
			didSignOut()
		}

		tabBar.barTintColor = Colors.tabBar
    }

	// SignInViewController
	func didSignIn() {
		setViewControllers([chatsNavigation, contactsNavigation, settingsNavigation], animated: true)
		tabBar.isHidden = false
	}
	// SettingsViewControllerSignOutDelegate
	func didSignOut() {
		setViewControllers([signInController], animated: true)
		tabBar.isHidden = true
	}

}
