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

import Algorithms
import Vapor

public struct PathMatcher<Return> {

    // MARK: - Properties

    let delimiter: String
    let options: Set<Option>

    private var matchers: [Matcher] = []

    // MARK: - Initialisation

    public init(delimiter: String = "/", options: Set<Option> = []) {
        self.delimiter = delimiter
        self.options = options
    }

}

// MARK: - Matching

public extension PathMatcher {

    mutating func match(_ string: String, returning: @autoclosure @escaping () -> Return) {
        let components = string
            .components(separatedBy: delimiter)
            .filter { $0.isEmpty == false }
            .map(PathComponent.init(stringLiteral:))

        guard components.isEmpty == false else {
            return
        }
        let matcher = Matcher(components: components) { _ in
            returning()
        }
        matchers.append(matcher)
    }

    mutating func match(_ string: String, _ returning: @escaping (Parameters) -> Return) {
        let components = string
            .components(separatedBy: delimiter)
            .filter { $0.isEmpty == false }
            .map(PathComponent.init(stringLiteral:))
        guard components.isEmpty == false else {
            return
        }

        let matcher = Matcher(components: components, returning: returning)
        matchers.append(matcher)
    }

    func parse(_ string: String) -> Return? {
        guard matchers.isEmpty == false, string.isEmpty == false else {
            return nil
        }

        let path = string.components(separatedBy: delimiter).filter { $0.isEmpty == false }

        for matcher in matchers {
            if let match = matcher.matches(path: path) {
                return matcher.returning(match)
            }
        }

        return nil
    }

    func parse(_ path: Path) -> Return? {
        parse(path.string)
    }

}

// MARK: - Matchers

private extension PathMatcher {

    struct Matcher {

        let components: [PathComponent]

        typealias Returning = (Parameters) -> Return
        let returning: Returning

        func matches(path: [String]) -> Parameters? {
            var parameters = Parameters()

            // we walk the path provided top to bottom
            for segment in path.indexed() {

                // are we beyond the end of our Path? Then we're not a match
                if segment.index >= components.endIndex {
                    return nil
                }

                switch components[segment.index] {

                // If we've reached a catch all then we can stop here
                case .catchall:
                    return parameters

                // Wildcard match (`*`)
                case .anything:
                    break

                // if its a constant part of the path then that needs to be the
                // same or we're not a match
                case let .constant(constant):
                    if constant != segment.element {
                        return nil
                    }

                // its a named parameter, so lets save it
                case let .parameter(name):
                    parameters.add(segment.element, for: name)
                }

            }

            // we reached the end of the path without hitting a catch all
            // but if our components list is longer then its only a partial
            // match not a full one
            guard components.endIndex == path.endIndex else {
                return nil
            }

            return parameters
        }

    }

}

// MARK: - Options

public extension PathMatcher {

    enum Option {

        /// Indicates that the PathMatcher should do its matching in a
        /// case insensitive manner. The default is to be case sensitive.
        case caseInsensitive
    }

}
