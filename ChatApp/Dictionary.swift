//
//  Dictionary.swift
//  Wire
//
//  Created by Will Tyler on 1/2/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import Foundation


extension Dictionary {

	func keys(where clause: (_ key: Key, _ value: Value)->(Bool)) -> [Key] {
		var keys = [Key]()

		for (key, value) in self {
			if clause(key, value) {
				keys.append(key)
			}
		}

		return keys
	}

}
