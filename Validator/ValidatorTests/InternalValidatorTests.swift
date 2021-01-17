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

    func testinitForContainsAndCondition() {
        let model = Model(name: "Hello 😀")
        let sut = Validator(contains: \Model.name, where: { $0 == "😀" }, message: "Expected to contain emoji 😀")

        XCTAssertEqual(sut.validate(model).count, 0)
    }

    func testCombiningValidators() {
        let model = Model(name: "Hello")

        let nonEmptyValidator = Validator(nonEmpty: \Model.name)
        let upperCaseValidator = Validator(contains: \Model.name, where: { $0.isUppercase }, message: "Should contain uppercase letter")

        let modelValidator = Validator(combining: [nonEmptyValidator, upperCaseValidator])

        XCTAssertEqual(modelValidator.validate(model).count, 0)
    }

    func testLiftValidatorGeneratesNewValidator() {
        let empty = Model(name: "")
        let nonEmpty = Model(name: "Hello")

        let expectedEmptyError = ValidationError(location:\Model.name, message: "Expected non-empty value")

        let nonEmptyString = Validator(nonEmpty: \String.self)
        let nonEmptyModelName = nonEmptyString.lift(\Model.name)


        XCTAssertEqual(nonEmptyModelName.validate(nonEmpty), [])

        XCTAssertEqual(nonEmptyModelName.validate(empty), [expectedEmptyError])
    }

    func testWithMessageChangesErrorMessage() {
        let empty = ""
        let nonEmpty = "some string"
        let newMessage = "some new message"

        let nonEmptyString = Validator(nonEmpty: \String.self)
        let nonEmptyWithMessage = nonEmptyString.with(message: newMessage)

        XCTAssertEqual(nonEmptyWithMessage.validate(nonEmpty), [])

        XCTAssertEqual(nonEmptyWithMessage.validate(empty), [ValidationError(location:\String.self, message: newMessage)])
    }
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
