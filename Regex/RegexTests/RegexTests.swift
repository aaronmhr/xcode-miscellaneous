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

    func matches(for string: String) -> Bool {
        let range = NSRange(location: .zero, length: string.utf16.count)
        return self.firstMatch(in: string, options: [], range: range) != nil
    }

    func isUncompliant(for string: String) -> Bool {
        return !matches(for: string)
    }
}


class RegexTests: XCTestCase {

    func testExample() throws {
        let regex = NSRegularExpression(for: #"\/|\\|[\u0000-\u001F]|[\u2000-\u200F]|[\u202E-\u202F]"#)

        XCTAssertNotNil(regex)

        XCTAssertTrue(regex.isUncompliant(for: "filename.txt"))
        XCTAssertFalse(regex.isUncompliant(for: "file\name.txt"))
        XCTAssertFalse(regex.isUncompliant(for: "file/name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
//        XCTAssertTrue(regex.isUncompliant(for: "file\name.txt"))
    }
}
