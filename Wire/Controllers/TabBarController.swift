//
//  TabBarController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController {

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

		tabBar.barTintColor = Colors.tabBar
    }

}
