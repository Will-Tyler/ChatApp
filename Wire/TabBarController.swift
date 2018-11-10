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
	private let settingsNavigation = UINavigationController(rootViewController: SettingsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

		settingsNavigation.navigationBar.prefersLargeTitles = true

		viewControllers = [pulsesNavigation, settingsNavigation]
    }

}
