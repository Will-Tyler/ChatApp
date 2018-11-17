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

	private var isSignedIn: Bool {
		get {
			return GIDSignIn.sharedInstance()!.hasAuthInKeychain()
		}
	}
	private lazy var signInController = SignInViewController()
	private lazy var pulsesNavigation = DarkNavigationContoller(rootViewController: PulsesViewController())
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

		viewControllers = [pulsesNavigation, settingsNavigation]
		selectedViewController = pulsesNavigation

		tabBar.barTintColor = Colors.tabBar
    }
	override func viewDidAppear(_ animated: Bool) {
		if !isSignedIn {
			present(signInController, animated: animated)
		}
	}

	func presentSignInController(animated: Bool) {
		present(signInController, animated: animated)
	}

}
