//
//  SplashViewController.swift
//  Wire
//
//  Created by Will Tyler on 11/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class SplashViewController: UIViewController {

	private let wireLabel: UILabel = {
		let label = UILabel()

		label.text = "Wire"
		label.font = label.font.withSize(64)
		label.textAlignment = .center

		return label
	}()

	private func setupInitialLayout() {
		view.subviews.forEach({ $0.removeFromSuperview() })

		let safeArea = view.safeAreaLayoutGuide

		view.addSubview(wireLabel)

		wireLabel.translatesAutoresizingMaskIntoConstraints = false
		wireLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
		wireLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
		wireLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
		wireLabel.heightAnchor.constraint(equalToConstant: wireLabel.intrinsicContentSize.height).isActive = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Colors.background
	}

}
