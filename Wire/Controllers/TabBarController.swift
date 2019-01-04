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
	private lazy var pulsesNavigation = DarkNavigationContoller(rootViewController: ChatsViewController())
	private lazy var contactsNavigation = DarkNavigationContoller(rootViewController: ContactsViewController())
	private lazy var settingsNavigation: DarkNavigationContoller = {
		let controller = DarkNavigationContoller(rootViewController: SettingsViewController(signOutDelegate: self))

		controller.navigationBar.prefersLargeTitles = true

		return controller
	}()

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
		setViewControllers([pulsesNavigation, contactsNavigation, settingsNavigation], animated: true)
		selectedViewController = pulsesNavigation
		tabBar.isHidden = false
	}
	// SettingsViewControllerSignOutDelegate
	func didSignOut() {
		setViewControllers([signInController], animated: true)
		tabBar.isHidden = true
	}

}
