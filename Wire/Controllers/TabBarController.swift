//
//  TabBarController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController {

	private let pulsesNavigation = UINavigationController(rootViewController: PulsesViewController())
	private let settingsNavigation: UINavigationController = {
		let controller = UINavigationController(rootViewController: SettingsViewController())

		controller.navigationBar.prefersLargeTitles = true

		return controller
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		viewControllers = [pulsesNavigation, settingsNavigation]
    }

}
