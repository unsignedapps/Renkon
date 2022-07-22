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

public struct ActionConfiguration: Codable, Equatable, Identifiable {

    // MARK: - Properties

    /// The unique identifier of the Action
    public var id: Action.Identifier

    /// The boxed configuration values
    var configuration: [Key: BoxedRenkonValue] = [:]


    // MARK: - Initialisation

    /// Memberwise initialiser for an ActionConfiguration
    public init(id: Identifier<RenkonNamespace.Action>, configurator: ((inout ActionConfiguration) -> Void)? = nil) {
        self.id = id
        if let configurator {
            configurator(&self)
        }
    }


    // MARK: - Confirming Types

    /// Throws an error if the receiving ``ActionConfiguration`` does not match the provided ID
    public func confirm(id: Action.Identifier) throws {
        guard self.id == id else {
            throw Error.identifierMismatch(got: id, expected: self.id)
        }
    }


    // MARK: - Boxing and Unboxing

    /// Boxes and stores a value inside this configuration
    public mutating func box(_ value: any RenkonValue, for key: Key) {
        configuration[key] = value.boxedValue
    }

    /// Attempts to unbox the value for the specified key
    public func unbox<Value>(_: Value.Type = Value.self, for key: Key) throws -> Value where Value: RenkonValue {
        guard let boxedValue = configuration[key] else {
            throw Error.propertyMissing(key)
        }
        guard let value = Value(boxedValue: boxedValue) else {
            throw Error.cannotUnbox(value: boxedValue, type: Value.self)
        }
        return value
    }

}


// MARK: - Configuration Errors

public extension ActionConfiguration {
    enum Error: Swift.Error {

        /// Attempted to initialise an action with the wrong ``ActionConfiguration``
        case identifierMismatch(got: Action.Identifier, expected: Action.Identifier)

        /// A required property was missing
        case propertyMissing(Key)

        /// Could not unbox the value into the specified type
        case cannotUnbox(value: BoxedRenkonValue, type: any RenkonValue.Type)

    }
}


// MARK: - Configuration Keys

public extension ActionConfiguration {

    /// A key type used to make working with ``ActionConfiguration``s easier (less strings)
    struct Key: RawRepresentable, ExpressibleByStringLiteral, Codable, Hashable {

        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            self.init(rawValue: value)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.init(rawValue: try container.decode(String.self))
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }

    }

}
