//
//  RegexTests.swift
//  RegexTests
//
//  Created by Aaron Huánuco on 14/1/21.
//

import XCTest
import Regex

extension NSRegularExpression {
    convenience init(for pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    func matches(_ text: String) -> Bool {
        let range = NSRange(location: .zero, length: text.utf16.count)
        return self.firstMatch(in: text, options: [], range: range) != nil
    }
}


class RegexTests: XCTestCase {

    func testExample() throws {
        let regex = NSRegularExpression(for: #"\/|\\|[\u0000-\u001F]|[\u2000-\u200F]|[\u202E-\u202F]"#)

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
}
