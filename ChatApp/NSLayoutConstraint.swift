//
//  NSLayoutConstraint.swift
//  Wire
//
//  Created by Will Tyler on 11/22/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


public extension NSLayoutConstraint {

	func activate() {
		isActive = true
	}
	func deactivate() {
		isActive = false
	}

}
