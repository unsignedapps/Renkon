//===----------------------------------------------------------------------===//
//
// This source file is part of the Renkon open source project
//
// Copyright (c) 2022 Unsigned Apps Pty Ltd. and the Renkon project authors
// Licensed under the MIT License
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

public struct Identifier<Namespace>: RawRepresentable, ExpressibleByStringLiteral, Equatable, Hashable {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init(_ string: String) {
        self.rawValue = string
    }

}


// MARK: - Codable Support

extension Identifier: Codable {

    public init(from decoder: Swift.Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

}


// MARK: - Boxable Support

extension Identifier: RenkonValue {

    public init?(boxedValue: BoxedRenkonValue?) {
        guard case let .string(value) = boxedValue else {
            return nil
        }
        self.init(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .string(rawValue)
    }

}
