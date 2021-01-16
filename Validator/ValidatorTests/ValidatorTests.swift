//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Aaron Huánuco on 16/1/21.
//

import XCTest
import Validator

final class ValidatorTests: XCTestCase {
    func testValidateValidatesString() {
        let error1 = ValidationError<String>(location: \.self, message: "error message 1")
        let error2 = ValidationError<String>(location: \.self, message: "error message 2")
        let error3 = ValidationError<String>(location: \.self, message: "error message 3")

        let sut = Validator<String>(validate: {
            var errors = [ValidationError<String>]()
            if $0.isEmpty {
                errors.append(error1)
            }

            if $0.contains("😀") {
                errors.append(error2)
            }

            if $0.count < 2 {
                errors.append(error3)
            }

            return errors

        })

        XCTAssertEqual(sut.validate("string"), [], "string should not break any rule")
        XCTAssertEqual(sut.validate("some string 😀"), [error2], "string should break rule 2")
        XCTAssertEqual(sut.validate("😀"), [error2, error3], "string should break rule 2 and 3")
        XCTAssertEqual(sut.validate(""), [error1, error3], "string should break rule 1 and 3")
    }

    func testValidateValidatesInt() {
        let error1 = ValidationError<Int>(location: \.self, message: "error message 1")

        let sut = Validator<Int>(validate: {
            var errors = [ValidationError<Int>]()

            if $0 > 2 {
                errors.append(error1)
            }

            return errors

        })

        XCTAssertEqual(sut.validate(3), [error1], "int should break rule 1")
        XCTAssertEqual(sut.validate(2), [], "int should not break any rule")
    }

    func testValidationCanValidatesInternalField() {
        struct SomeStruct {
            let name: String
        }
        let someClass = SomeStruct(name: "a name")
        let someClassEmptyName = SomeStruct(name: "")

        let error1 = ValidationError(location: \SomeStruct.name, message: "error message 1")

        let sut = Validator<SomeStruct>(validate: {
            var errors = [ValidationError<SomeStruct>]()

            if $0.name.isEmpty {
                errors.append(error1)
            }

            return errors

        })

        XCTAssertEqual(sut.validate(someClass), [], "field should not break any rule")
        XCTAssertEqual(sut.validate(someClassEmptyName), [error1], "field should break any empty rule")
    }
}
