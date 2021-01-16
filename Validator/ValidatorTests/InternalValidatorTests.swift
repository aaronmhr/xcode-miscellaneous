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
        let empty = ViewModel(id: "", model: Model(name: ""))
        let nonEmpty = ViewModel(id: "some id", model: Model(name: "some name"))

        XCTAssertEqual(Validator(nonEmpty: \ViewModel.id).validate(empty).count, 1)
        XCTAssertEqual(Validator(nonEmpty: \ViewModel.id).validate(nonEmpty).count, 0)
        XCTAssertEqual(Validator(nonEmpty: \ViewModel.model.name).validate(empty).count, 1)
        XCTAssertEqual(Validator(nonEmpty: \ViewModel.model.name).validate(nonEmpty).count, 0)
    }

    private class ViewModel {
        let id: String
        let model: Model

        init(id: String, model: Model) {
            self.id = id
            self.model = model
        }
    }

    private struct Model {
        let name: String
    }
}
