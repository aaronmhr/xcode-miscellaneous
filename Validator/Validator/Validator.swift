//
//  Validator.swift
//  Validator
//
//  Created by Aaron Huánuco on 16/1/21.
//

import Foundation

public struct Validator<T> {
    public let validate: (T) -> [ValidationError<T>]

    public init(validate: @escaping (T) -> [ValidationError<T>]) {
        self.validate = validate
    }
}

public struct ValidationError<T>: Error, Equatable {
    public let location: PartialKeyPath<T>
    public let message: String

    public init(location: PartialKeyPath<T>, message: String) {
        self.location = location
        self.message = message
    }
}
