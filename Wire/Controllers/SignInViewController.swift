//
//  SignInViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class SignInViewController: UIViewController {

	private let wireLabel: UILabel = {
		let label = UILabel()

		label.text = "Wire"
		label.textColor = .white
		label.font = label.font.withSize(64)
		label.textAlignment = .center

		return label
	}()
	private let segmentedControl: UISegmentedControl = {
		let items = ["Login", "Register"]
		let control = UISegmentedControl(items: items)

		control.selectedSegmentIndex = 0
		control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

		return control
	}()
	private let fieldContainer: UIView = {
		let view = UIView()

		view.backgroundColor = .white
		view.layer.masksToBounds = false
		view.layer.cornerRadius = 5

		return view
	}()
	private let nameField: UITextField = {
		let field = UITextField()

		field.placeholder = "Display Name"

		return field
	}()
	private let emailField: UITextField = {
		let field = UITextField()

		field.placeholder = "Email"
		field.keyboardType = .emailAddress

		return field
	}()
	private let passwordField: UITextField = {
		let field = UITextField()

		field.placeholder = "Password"
		field.isSecureTextEntry = true

		return field
	}()
	private lazy var button: UIButton = {
		let button = UIButton()
		let title = NSAttributedString(string: "Login", attributes: [.foregroundColor : segmentedControl.tintColor])

		button.backgroundColor = Colors.background
		button.setAttributedTitle(title, for: .normal)
		button.setTitleColor(Colors.background, for: .normal)

		button.layer.masksToBounds = false
		button.layer.cornerRadius = 5
		button.layer.borderWidth = 1
		button.layer.borderColor = segmentedControl.tintColor.cgColor

		button.addTarget(self, action: #selector(toggleButtonColors), for: .touchDown)
		button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)

		return button
	}()
	private var fieldContainerHeightConstraint: NSLayoutConstraint!
	private var nameFieldHeightConstraint: NSLayoutConstraint!
	private var emailFieldHeightConstraint: NSLayoutConstraint!
	private var passwordFieldHeightConstraint: NSLayoutConstraint!

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		fieldContainer.addSubview(nameField)
		fieldContainer.addSubview(emailField)
		fieldContainer.addSubview(passwordField)

		nameField.translatesAutoresizingMaskIntoConstraints = false
		nameField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 16).isActive = true
		nameField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor).isActive = true
		nameField.topAnchor.constraint(equalTo: fieldContainer.topAnchor).isActive = true
		nameFieldHeightConstraint = nameField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 0)
		nameFieldHeightConstraint.isActive = true

		emailField.translatesAutoresizingMaskIntoConstraints = false
		emailField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 16).isActive = true
		emailField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor).isActive = true
		emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
		emailFieldHeightConstraint = emailField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/2)
		emailFieldHeightConstraint.isActive = true

		passwordField.translatesAutoresizingMaskIntoConstraints = false
		passwordField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 16).isActive = true
		passwordField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor).isActive = true
		passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
		passwordFieldHeightConstraint = passwordField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/2)
		passwordFieldHeightConstraint.isActive = true

		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(fieldContainer)
		view.addSubview(button)
		view.addSubview(segmentedControl)
		view.addSubview(wireLabel)

		fieldContainer.translatesAutoresizingMaskIntoConstraints = false
		fieldContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
		fieldContainer.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
		fieldContainer.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -32).isActive = true
		fieldContainerHeightConstraint = fieldContainer.heightAnchor.constraint(equalToConstant: 100)
		fieldContainerHeightConstraint.isActive = true

		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
		segmentedControl.widthAnchor.constraint(equalTo: fieldContainer.widthAnchor).isActive = true
		segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
		segmentedControl.bottomAnchor.constraint(equalTo: fieldContainer.topAnchor, constant: -16).isActive = true

		wireLabel.translatesAutoresizingMaskIntoConstraints = false
		wireLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
		wireLabel.heightAnchor.constraint(equalToConstant: wireLabel.intrinsicContentSize.height).isActive = true
		wireLabel.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor).isActive = true
		wireLabel.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -16).isActive = true

		button.translatesAutoresizingMaskIntoConstraints = false
		button.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 16).isActive = true
		button.leftAnchor.constraint(equalTo: fieldContainer.leftAnchor).isActive = true
		button.rightAnchor.constraint(equalTo: fieldContainer.rightAnchor).isActive = true
		button.heightAnchor.constraint(equalToConstant: 32).isActive = true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background

		setupInitialLayout()

		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))

		view.addGestureRecognizer(tapRecognizer)
	}

	@objc
	private func endEditing() {
		view.endEditing(true)
	}

	private var mode: Mode {
		get {
			switch segmentedControl.selectedSegmentIndex {
			case 0:
				return .login

			case 1:
				return .register

			default: fatalError()
			}
		}
	}

	@objc
	private func segmentedControlValueChanged() {
		switch mode {
		case .login:
			button.setAttributedTitle(buttonLoginTitle, for: .normal)

			fieldContainerHeightConstraint.constant = 100

			nameFieldHeightConstraint.isActive = false
			emailFieldHeightConstraint.isActive = false
			passwordFieldHeightConstraint.isActive = false

			nameFieldHeightConstraint = nameField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 0)
			emailFieldHeightConstraint = emailField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/2)
			passwordFieldHeightConstraint = passwordField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/2)

			nameFieldHeightConstraint.isActive = true
			emailFieldHeightConstraint.isActive = true
			passwordFieldHeightConstraint.isActive = true

		case .register:
			button.setAttributedTitle(buttonRegisterTitle, for: .normal)

			fieldContainerHeightConstraint.constant = 150

			nameFieldHeightConstraint.isActive = false
			emailFieldHeightConstraint.isActive = false
			passwordFieldHeightConstraint.isActive = false

			nameFieldHeightConstraint = nameField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/3)
			emailFieldHeightConstraint = emailField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/3)
			passwordFieldHeightConstraint = passwordField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor, multiplier: 1/3)

			nameFieldHeightConstraint.isActive = true
			emailFieldHeightConstraint.isActive = true
			passwordFieldHeightConstraint.isActive = true
		}
	}

	// Button
	private var buttonIsPressed = false
	private lazy var buttonLoginTitle = NSAttributedString(string: "Login", attributes: [.foregroundColor: segmentedControl.tintColor])
	private lazy var buttonRegisterTitle = NSAttributedString(string: "Register", attributes: [.foregroundColor: segmentedControl.tintColor])
	@objc
	private func toggleButtonColors() {
		buttonIsPressed.toggle()

		if buttonIsPressed {
			button.backgroundColor = segmentedControl.tintColor

			let currentTitle = button.currentAttributedTitle!
			let newTitle = NSAttributedString(string: currentTitle.string, attributes: [.foregroundColor: Colors.background])

			button.setAttributedTitle(newTitle, for: .normal)
		}
		else {
			button.backgroundColor = Colors.background
			button.setAttributedTitle(mode == .login ? buttonLoginTitle : buttonRegisterTitle, for: .normal)
		}
	}
	@objc
	private func buttonReleased() {
		toggleButtonColors()

		guard let email = emailField.text, email.isValidEmail else {
			alertUser(title: "Invalid Email", message: "Please enter a valid email.")
			return
		}
		guard let password = passwordField.text, password.isValidPassword else {
			alertUser(title: "Invalid Password", message: "Password must be 8 to 16 characters long and include at least one uppercase, lowercase, and digit. Do not use symbols.")
			return
		}

		let tabBarController = presentingViewController!

		switch mode {
		case .login:
			Firebase.signIn(email: email, password: password, completion: { error in
				guard error == nil else {
					self.alertUser(title: "Error Signing In", message: error!.localizedDescription)
					return
				}

				tabBarController.dismiss(animated: true)
			})

		case .register:
			guard let displayName = nameField.text, displayName.isValidDisplayName else {
				self.alertUser(title: "Invalid Display Name", message: "Please enter a display name in the form of 'First Last'.")
				return
			}

			Firebase.createUser(email: email, password: password, displayName: displayName, completion: {
				tabBarController.dismiss(animated: true)
			}, error: { error in
				self.alertUser(title: "Error Signing In", message: error.localizedDescription)
			})
		}
	}

	var isSignedIn: Bool {
		get {
			return Firebase.currentID != nil
		}
	}

}


fileprivate enum Mode {

	case login
	case register

}
