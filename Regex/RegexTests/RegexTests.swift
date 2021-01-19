//
//  RegexTests.swift
//  RegexTests
//
//  Created by Aaron Huánuco on 14/1/21.
//

import XCTest
import Regex

class RegexTests: XCTestCase {

    func testExample() throws {
        let regex = NSRegularExpression( #"\/|\\|[\u0000-\u001F]|[\u2000-\u200F]|[\u202E-\u202F]"#)

        XCTAssertNotNil(regex)

        XCTAssertFalse(regex.matches("txt"), "Normal text should be allowed")
        XCTAssertFalse(regex.matches(""), "Normal text should be allowed")
        XCTAssertFalse(regex.matches("filename.txt"), "Normal text should be allowed")
        XCTAssertFalse(regex.matches("my file"), "Normal space should be allowed")

        XCTAssertTrue(regex.matches("my file"), "Do not allow U+2000")
        XCTAssertTrue(regex.matches("my file"), "Do not allow U+2001")
        XCTAssertTrue(regex.matches("my file"), "Do not allow U+2002")
        XCTAssertTrue(regex.matches("my file"), "Do not allow U+2003")
        XCTAssertTrue(regex.matches("file\name.txt"), "Do not allow backslash")
        XCTAssertTrue(regex.matches("file/name.txt"), "Do not allow slash")

    }

    func testLeadingTrailingBlankSpace() {
        let regex = NSRegularExpression(#"^[^\s].+[^\s]$"#)

        XCTAssertTrue(regex.matches("hello"))
        XCTAssertFalse(regex.matches(" hello"))
        XCTAssertFalse(regex.matches("hello "))
        XCTAssertFalse(regex.matches(" hello "))
    }

    func testLeadingBlankSpace() {
        let regex = NSRegularExpression(#"^\s+"#)

        XCTAssertFalse(regex.matches("hello"))
        XCTAssertTrue(regex.matches(" hello"))
        XCTAssertFalse(regex.matches("hello "))
        XCTAssertTrue(regex.matches(" hello "))
        XCTAssertTrue(regex.matches("  hello"))
    }
}
