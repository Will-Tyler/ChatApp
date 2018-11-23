//
//  Array.swift
//  Wire
//
//  Created by Will Tyler on 11/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension Array {

	mutating func replace(at index: Int, with new: Element) {
		replaceSubrange(index..<index+1, with: [new])
	}

}
