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

	func indices(where condition: (Element)->Bool) -> [Int] {
		var indices = [Int]()

		for index in 0..<count {
			if condition(self[index]) {
				indices.append(index)
			}
		}

		return indices
	}

	mutating func remove(at indices: [Int]) {
		for index in indices {
			remove(at: index)
		}
	}

}
