//
//  InternalValidatorTests.swift
//  ValidatorTests
//
//  Created by Aaron Huánuco on 16/1/21.
//

import XCTest
@testable import Validator

final class InternalValidatorTests: XCTestCase {
    func testInitWithGenericValue() {
        let emptyNode = ViewModel(node: "")
        let nonEmptyNode = ViewModel(node: "node")

        let sut = Validator(nonEmpty: \ViewModel.node)

        XCTAssertEqual(sut.validate(emptyNode).count, 1)
        XCTAssertEqual(sut.validate(nonEmptyNode).count, 0)
    }

    private class ViewModel {
        let node: String

        init(node: String) {
            self.node = node
        }
    }
}
