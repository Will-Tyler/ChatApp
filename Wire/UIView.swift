//
//  UIView.swift
//  Wire
//
//  Created by Will Tyler on 11/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


extension UIView {

	var controller: UIViewController? {
		get {
			if let controller = next as? UIViewController {
				return controller
			}
			else if let view = next as? UIView {
				return view.controller
			}
			else {
				return nil
			}
		}
	}

}
