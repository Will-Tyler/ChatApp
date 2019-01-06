//
//  WireTests.swift
//  WireTests
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import XCTest
@testable import Wire


class WireTests: XCTestCase {

	func testIsValidPassword() {
		var pass = ""
		XCTAssertFalse(pass.isValidPassword)

		pass = "0"
		XCTAssertFalse(pass.isValidPassword)

		pass = "1234567"
		XCTAssertFalse(pass.isValidPassword)

		pass = "12345678"
		XCTAssertFalse(pass.isValidPassword)

		pass = "abcdefgh"
		XCTAssertFalse(pass.isValidPassword)

		pass = "abcdefg8"
		XCTAssertFalse(pass.isValidPassword)

		pass = "123456789aBcdefg"
		XCTAssertTrue(pass.isValidPassword)

		pass.append("0")
		XCTAssertFalse(pass.isValidPassword)

		pass = "123 56789"
		XCTAssertFalse(pass.isValidPassword)

		pass = " 23456789"
		XCTAssertFalse(pass.isValidPassword)

		pass = "12345678 "
		XCTAssertFalse(pass.isValidPassword)

		pass = "124452gba3"
		XCTAssertFalse(pass.isValidPassword)
	}

	private func testValidName(name: String, _ expected: Bool) {
		if expected {
			XCTAssertTrue(name.isValidDisplayName)
		}
		else {
			XCTAssertFalse(name.isValidDisplayName)
		}
	}

	func testValidDisplayName() {
		testValidName(name: "Will Tyler", true)
		testValidName(name: "", false)
		testValidName(name: "Will  Tyler", false)
		testValidName(name: " Will Tyler", false)
		testValidName(name: "Will Tyler ", false)
		testValidName(name: "Will", false)
		testValidName(name: "Wi Ty", false)
		testValidName(name: "Wil Tyl", true)
	}

}
