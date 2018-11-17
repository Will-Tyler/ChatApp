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

	private let wireLabel: UILabel = {
		let label = UILabel()

		label.text = "Wire"
		label.font = label.font.withSize(64)
		label.textColor = .white
		label.textAlignment = .center

		return label
	}()
	private let signInButton = GIDSignInButton()

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(wireLabel)
		view.addSubview(signInButton)

		signInButton.translatesAutoresizingMaskIntoConstraints = false
		signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		signInButton.heightAnchor.constraint(equalToConstant: 256).isActive = true
		signInButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8).isActive = true

		wireLabel.translatesAutoresizingMaskIntoConstraints = false
		wireLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		wireLabel.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor, constant: -128).isActive = true
		wireLabel.heightAnchor.constraint(equalToConstant: 128).isActive = true
		wireLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		GIDSignIn.sharedInstance().uiDelegate = self

		view.backgroundColor = Colors.background

		setupInitialLayout()
    }

}
