//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Aaron Huánuco on 16/1/21.
//

import XCTest
import Validator

struct Validator<T> {
    let validate: (T) -> [ValidationError<T>]
}

struct ValidationError<T>: Error, Equatable {
    let location: PartialKeyPath<T>
    let message: String
}

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

    func testValidationSupportsValidationForIntToo() {
        let error1 = ValidationError<Int>(location: \.self, message: "error message 1")

        let sut = Validator<Int>(validate: {
            var errors = [ValidationError<Int>]()

            if $0 > 2 {
                errors.append(error1)
            }

            return errors

        })

        XCTAssertEqual(sut.validate(3), [error1], "Should give error for numbers greater than 2")
        XCTAssertEqual(sut.validate(2), [], "Should not give error for numbers smaller or equal than 2")
    }

    func testValidationCanValidatesInternalField() {
        let error1 = ValidationError(location: \SomeClass.name, message: "error message 1")

        struct SomeClass {
            let name: String
        }

        let someClass = SomeClass(name: "a name")
        let someClassEmptyName = SomeClass(name: "")

        let sut = Validator<SomeClass>(validate: {
            var errors = [ValidationError<SomeClass>]()

            if $0.name.isEmpty {
                errors.append(error1)
            }

            return errors

        })

        XCTAssertEqual(sut.validate(someClass), [])
        XCTAssertEqual(sut.validate(someClassEmptyName), [error1])
    }
}
