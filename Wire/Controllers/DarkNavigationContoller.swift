//
//  DarkNavigationContoller.swift
//  Wire
//
//  Created by Will Tyler on 11/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit

class DarkNavigationContoller: UINavigationController {

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationBar.barTintColor = Colors.navigationBar
		navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
		navigationBar.largeTitleTextAttributes = navigationBar.titleTextAttributes
    }

}
