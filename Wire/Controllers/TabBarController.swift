//
//  TabBarController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class TabBarController: UITabBarController {

	private lazy var signInController = SignInViewController()
	private lazy var pulsesNavigation = DarkNavigationContoller(rootViewController: ChatsViewController())
	private lazy var contactsNavigation = DarkNavigationContoller(rootViewController: ContactsViewController())
	private lazy var settingsNavigation: DarkNavigationContoller = {
		let controller = DarkNavigationContoller(rootViewController: SettingsViewController())

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

		viewControllers = [pulsesNavigation, contactsNavigation, settingsNavigation]
		selectedViewController = pulsesNavigation

		tabBar.barTintColor = Colors.tabBar
    }
	override func viewDidAppear(_ animated: Bool) {
		if !signInController.isSignedIn {
			present(signInController, animated: animated)
		}
	}

	func presentSignInController(animated: Bool) {
		present(signInController, animated: animated)
	}
	func dismissSignInController(animated: Bool) {
		dismiss(animated: animated)
	}

}
