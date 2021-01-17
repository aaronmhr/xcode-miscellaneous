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

extension Validator {
    init<Value: Collection>(nonEmpty keyPath: KeyPath<T, Value>) {
        validate = { t in
            guard !t[keyPath: keyPath].isEmpty else {
                return [ValidationError(location: keyPath, message: "Expected non-empty value")]
            }
            return []
        }
    }

    init<Value: Collection>(contains keyPath: KeyPath<T, Value>, where condition: @escaping (Value.Element) -> Bool, message: String) {
        validate = { t in
            guard t[keyPath: keyPath].contains(where: condition) else {
                return [ValidationError(location: keyPath, message: message)]
            }
            return []
        }
    }

    init(combining validators: [Validator<T>]) {
        validate = { t in
            validators.flatMap { $0.validate(t) }
        }
    }

    func lift<Target>(_ keyPath: KeyPath<Target, T>) -> Validator<Target> {
        return Validator<Target> { target in
            let errors = validate(target[keyPath: keyPath])
            return errors.map { error in
                let kp = keyPath as PartialKeyPath<Target>
                let newLocation = kp.appending(path: error.location)!
                return ValidationError(location: newLocation, message: error.message)
            }
        }
    }

    func with(message: String) -> Validator<T> {
        return Validator { t in
            let errors = validate(t)
            return errors.map { error in
                ValidationError(location: error.location, message: message)
            }
        }
    }
}
