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
        let emptyId = ViewModel(id: "")
        let nonEmptyId = ViewModel(id: "id")

        let sut = Validator(nonEmpty: \ViewModel.id)

        XCTAssertEqual(sut.validate(emptyId).count, 1)
        XCTAssertEqual(sut.validate(nonEmptyId).count, 0)
    }

    private class ViewModel {
        let id: String

        init(id: String) {
            self.id = id
        }
    }
}
