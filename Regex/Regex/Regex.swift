//
//  Regex.swift
//  Regex
//
//  Created by Aaron Huánuco on 14/1/21.
//

import Foundation

public extension NSRegularExpression {
    convenience init(_ pattern: String) {
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
