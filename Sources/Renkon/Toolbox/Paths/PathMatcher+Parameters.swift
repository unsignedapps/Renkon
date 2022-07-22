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

public extension PathMatcher {

    /// A `Collection` of the parameters that were matched by a `PatchMatcher.match` method.
    ///
    /// Positional parameters can be subscripted by their index, while named parameters can be
    /// subscripted by name or index, eg.
    ///
    /// ```swift
    /// matcher.match("/path/:first/more/:last") { parameters in
    ///     // parameters[0] is the first "?"
    ///     // parameters[1] is the parameter named ":last"
    ///     // parameters["last"] also works
    /// }
    /// ```
    ///
    struct Parameters {

        // MARK: - Properties

        private var parameters: [Parameter] = []

        // MARK: - Initialisation

        init() {
            // Intentionally left blank
        }

        // MARK: - Adding Parameters

        mutating func add(_ value: String) {
            parameters.append(.position(value: value))
        }

        mutating func add(_ value: String, for key: String) {
            parameters.append(.named(key: key, value: value))
        }

        // MARK: - Subscripting

        /// Retrieves the positional or named parameter at the given position
        public subscript(_ position: Int) -> String {
            parameters[position].value
        }

        /// Retrieves the parameter with the given name
        public subscript(_ name: String) -> String? {
            for parameter in parameters {
                if case let .named(key, value) = parameter, key == name {
                    return value
                }
            }
            return nil
        }

    }

}

// MARK: - Parameter Type

private extension PathMatcher {
    enum Parameter {
        case position(value: String)
        case named(key: String, value: String)

        var value: String {
            switch self {
            case let .position(value):
                return value
            case let .named(_, value):
                return value
            }
        }
    }
}
