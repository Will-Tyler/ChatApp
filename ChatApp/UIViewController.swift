//
//  UIViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


extension UIViewController {

	func alertUser(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alertController.addAction(UIAlertAction(title: "OK", style: .default))

		present(alertController, animated: true)
	}

}
