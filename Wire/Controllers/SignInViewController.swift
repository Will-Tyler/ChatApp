//
//  LoginViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class SignInViewController: UIViewController, GIDSignInUIDelegate {

	private let signInButton = GIDSignInButton()

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(signInButton)

		signInButton.translatesAutoresizingMaskIntoConstraints = false
		signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		signInButton.heightAnchor.constraint(equalToConstant: 128).isActive = true
		signInButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8).isActive = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .white

		title = "Google Sign-In"
		tabBarItem.title = "Sign-In"

		setupInitialLayout()

		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().signIn()
    }

}
