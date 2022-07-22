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

public extension Scenario {

    /// Available configuration options for a Scenario
    ///
    /// You can add your own custom options to this type by extension. Any type that conforms to
    /// ``RenkonValue`` can be used.
    ///
    /// ```swift
    /// enum AccessControlLevel: String, RenkonValue {
    ///     case visitor
    ///     case author
    ///     case admin
    /// }
    ///
    /// private extension Scenario.Options.Key where Value == AccessControlLevel {
    ///    static let minACL = Scenario.Options.Key(name: "acl", defaultValue: .visitor)
    /// }
    ///
    /// extension Scenario.Options {
    ///     var minACL: AccessControlLevel {
    ///         get { unbox(key: .minACL) }
    ///         set { box(newValue, for: .minACL) }
    ///     }
    /// }
    /// ```
    ///
    struct Options: Codable {

        // MARK: - Configuration Options

        /// The maximum length of time that streams are allowed to stay connected for
        public var maximumStreamLifetimeNanoseconds: UInt64 = .max

        /// The delay to apply to all requests, if any.
        ///
        /// This option allows you to simulate poor network conditions or a slow server by
        /// applying a delay to the receiving of the request from the client. This delay is applied
        /// immediately upon receipt of the connection, prior to the Action being called. All
        /// subsequent actions will be called immediately.
        public var delayAllRequests: RenkonDuration?


        // MARK: - Custom Option Storage

        /// Custom Options that you can use to extend the those available on the scenario
        public var customOptions: [String: BoxedRenkonValue] = [:]


        // MARK: - Initialisation

        /// Initialises a new set of Scenario Options using all the default values
        public init() {
            // Intentionally left blank
        }


        // MARK: - Boxing and Unboxing

        /// Boxes and stores a value inside this configuration
        public mutating func box<Value>(_ value: Value, for key: Key<Value>) where Value: RenkonValue {
            customOptions[key.name] = value.boxedValue
        }

        /// Attempts to unbox the value for the specified key
        public func unbox<Value>(_: Value.Type = Value.self, key: Key<Value>) throws -> Value where Value: RenkonValue {
            guard let boxedValue = customOptions[key.name], let value = Value(boxedValue: boxedValue) else {
                return key.makeDefaultValue()
            }
            return value
        }

    }

}


// MARK: - Option Keys

public extension Scenario.Options {

    /// A key type used to make working with ``ActionConfiguration``s easier (less strings)
    struct Key<Value> where Value: RenkonValue {

        /// The "name" of this key. This value is used as the storage dictionary key.
        var name: String

        /// The default value to use for this option, if one is not able to be unboxed
        var makeDefaultValue: () -> Value

        public init(name: String, defaultValue: @autoclosure @escaping () -> Value) {
            self.name = name
            self.makeDefaultValue = defaultValue
        }

    }

}
