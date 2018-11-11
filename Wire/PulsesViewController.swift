//
//  FirstViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class PulsesViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Pulses"

		view.backgroundColor = .white

		let delegate = UIApplication.shared.delegate as! AppDelegate

		if !delegate.isSignedIn {
			navigationController!.pushViewController(SignInViewController(), animated: true)
		}
	}

}
