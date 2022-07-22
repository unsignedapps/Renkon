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

@resultBuilder
public enum CollectionBuilder<Element> {

    /// The component type to compose expressions into. This is also the `FinalResult`.
    ///
    public typealias Component = [Element]

    // MARK: - Building Expressions

    /// Basic support for turning an `Element` into a `Component`
    ///
    /// See `CollectionBuilderTests.testSingleElement` for example usage
    ///
    public static func buildExpression(_ expression: Element) -> Component {
        [expression]
    }

    /// Support for optional `Element`s in the result.
    ///
    /// See `CollectionBuilderTests.testOptionals` for example usage
    ///
    public static func buildExpression(_ expression: Element?) -> Component {
        expression.map { [$0] } ?? []
    }

    /// Support for consuming a sequence of elements.
    ///
    /// See `CollectionBuilderTests.testSequencesOfElements` for example usage
    ///
    public static func buildExpression<Expression>(_ expression: Expression) -> Component where Expression: Sequence, Expression.Element == Element {
        Array(expression)
    }

    /// Support for consuming an optional sequence of elements.
    ///
    public static func buildExpression<Expression>(_ expression: Expression?) -> Component where Expression: Sequence, Expression.Element == Element {
        expression.map(Array.init) ?? []
    }

    // MARK: - Building Blocks & Components

    /// Support for result builders that return no children or void
    ///
    /// See `CollectionBuilderTests.testEmpty` for example usage
    ///
    public static func buildBlock() -> Component {
        []
    }

    /// Support for multiple lines of `Component`s. This also constructs the `FinalResult`.
    ///
    /// See `CollectionBuilderTests.testSingleComponent`.
    /// `CollectionBuilderTests.testMultipleComponents`, and
    /// `CollectionBuilderTests.testSwiftStatement` for example usage
    ///
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    // MARK: - Building Conditionals

    /// Support for single-branch conditional statements (eg an `if` statement without an `else` branch)
    ///
    /// See `CollectionBuilderTests.testIfStatementWithSingleBranch` for example usage
    ///
    public static func buildOptional(_ components: Component?) -> Component {
        components ?? []
    }

    /// Support for multi-branch conditional statements (eg an `if` statement with an `else` branch)
    ///
    /// See `CollectionBuilderTests.testIfStatementFirstBranch` for example usage
    ///
    public static func buildEither(first: Component) -> Component {
        first
    }

    /// Support for multi-branch conditional statements (eg an `if` statement with an `else` branch)
    ///
    /// See `CollectionBuilderTests.testIfStatementSecondBranch` for example usage
    ///
    public static func buildEither(second: [Element]) -> Component {
        second
    }

    /// Support for `if #available` statements, we don't really need this as we're not trying
    /// to type-erase whats inside the availability statement, but @bok is a completionist so ¯\_(ツ)_/¯
    ///
    /// See `CollectionBuilderTests.testLimitedAvailability` for example usage
    ///
    public static func buildLimitedAvailability(_ components: [Element]) -> Component {
        components
    }

}

// MARK: - Array Support

public extension Array {

    /// Initialises an Array with the results returned by a function builder
    ///
    /// For example:
    ///
    /// ```swift
    /// var cancellables = Array {
    ///     publisher1.sink {}
    ///     publisher2.sink {}
    /// }
    ///
    /// var integers = Array {
    ///     1
    ///     2
    ///     3
    /// }
    /// ```
    ///
    init(@CollectionBuilder<Element> collecting: () -> [Element]) {
        self = collecting()
    }

    /// Adds the results of the function builder to the Array
    ///
    /// For example:
    ///
    /// ```swift
    /// var cancellables: [AnyCancellable] = []
    /// cancellables.collect {
    ///     publisher1.sink {}
    ///     publisher2.sink {}
    /// }
    ///
    /// var integers: [Int] = []
    /// integers.collect {
    ///     1
    ///     2
    ///     3
    /// }
    /// ```
    ///
    mutating func collect(@CollectionBuilder<Element> _ builder: () -> [Element]) {
        append(contentsOf: builder())
    }
}

// MARK: - Set Support

public extension Set {

    /// Initialises a Set with the results returned by a function builder
    ///
    /// For example:
    ///
    /// ```swift
    /// var cancellables = Set {
    ///     publisher1.sink {}
    ///     publisher2.sink {}
    /// }
    ///
    /// var integers = Set {
    ///     1
    ///     2
    ///     3
    /// }
    /// ```
    ///
    init(@CollectionBuilder<Element> collecting: () -> [Element]) {
        self.init(collecting())
    }

    /// Adds the results of the function builder to the Set
    ///
    /// For example:
    ///
    /// ```swift
    /// var cancellables = Set<AnyCancellable>()
    /// cancellables.collect {
    ///     publisher1.sink {}
    ///     publisher2.sink {}
    /// }
    ///
    /// var integers = Set<Int>()
    /// integers.collect {
    ///     1
    ///     2
    ///     3
    /// }
    /// ```
    ///
    mutating func collect(@CollectionBuilder<Element> _ builder: () -> [Element]) {
        for element in builder() {
            insert(element)
        }
    }
}
