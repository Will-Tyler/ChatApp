//
//  Colors.swift
//  Wire
//
//  Created by Will Tyler on 11/16/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


struct Colors {

	static let background = UIColor(red: 0x29, green: 0x2a, blue: 0x30)
	static let header = UIColor(white: 0x34)
	static let tabBar = UIColor(white: 55)
	static let navigationBar = UIColor(white: 55)

}


fileprivate extension UIColor {

	convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
		self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
	}
	convenience init(white: CGFloat) {
		self.init(white: white / 255, alpha: 1)
	}

}
