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

import Vapor

/// A representation of a path on a file system, whether local or remote
public struct Path: Equatable, Hashable {

    // MARK: - Properties

    private let path: String
    private let delimiter: String
    private let components: [String]

    // MARK: - Initialisation

    public init<S>(_ path: S, delimiter: String = "/") where S: StringProtocol {
        self.path = String(path)
        self.delimiter = delimiter
        self.components = path.components(separatedBy: delimiter).filter { $0.isEmpty == false }
    }

    // MARK: - Parts

    /// A string representation of the path.
    public var string: String {
        path
    }

    /// The last path component (including any extension).
    public var lastComponent: String {
        // Check for a special case of the root directory.
        if path == delimiter {
            return path
        }

        // No path separators, so the basename is the whole string.
        guard let idx = path.lastIndex(of: Character(delimiter)) else {
            return path
        }

        // Otherwise, it's the string from (but not including) the last path separator.
        return String(path.suffix(from: path.index(after: idx)))
    }

    /// The last path component (without any extension).
    public var stem: String {
        let filename = lastComponent
        if let ext = self.extension {
            return String(filename.dropLast(ext.count + 1))
        } else {
            return filename
        }
    }

    /// The filename extension, if any (without any leading dot).
    public var `extension`: String? {
        // Find the last path separator, if any.
        let sIdx = path.lastIndex(of: Character(delimiter))

        // Find the start of the basename.
        let bIdx = (sIdx != nil) ? path.index(after: sIdx!) : path.startIndex

        // Find the last `.` (if any), starting from the second character of
        // the basename (a leading `.` does not make the whole path component
        // a suffix).
        let fIdx = path.index(bIdx, offsetBy: 1, limitedBy: path.endIndex) ?? path.startIndex
        if let idx = path[fIdx...].lastIndex(of: ".") {
            // Unless it's just a `.` at the end, we have found a suffix.
            if path.distance(from: idx, to: path.endIndex) > 1 {
                return String(path.suffix(from: path.index(idx, offsetBy: 1)))
            }
        }
        // If we get this far, there is no suffix.
        return nil
    }

    /// The path except for the last path component.
    public func removingLastComponent() -> Path {
        // Find the last path separator.
        guard let idx = path.lastIndex(of: Character(delimiter)) else {
            // No path separators, so the directory name is `.`.
            return Path(".")
        }
        // Check if it's the only one in the string.
        if idx == string.startIndex {
            // Just one path separator, so the directory name is `/`.
            return Path(delimiter)
        }
        // Otherwise, it's the string up to (but not including) the last path
        // separator.
        return Path(String(path.prefix(upTo: idx)))
    }

    /// The path except for the first path component
    public func removingFirstComponent() -> Path {
        var components = components
        components.removeFirst()
        return Path(components.joined(separator: delimiter), delimiter: delimiter)
    }

    /// The result of appending one or more path components.
    public func appending(_ components: [String]) -> Path {
        Path(path.appending(delimiter).appending(components.joined(separator: delimiter)))
    }

    /// The result of appending one or more path components.
    public func appending(_ components: String...) -> Path {
        appending(components)
    }

    // MARK: - Prefixes and suffixes

    /// Returns a boolean indicating whether the Path begins with the specified Path
    public func hasPrefix(_ path: Path) -> Bool {
        self.path.hasPrefix(path.path)
    }

    /// Returns a boolean indicating whether the Path ends with the specified Path
    public func hasSuffix(_ path: Path) -> Bool {
        self.path.hasSuffix(path.path)
    }

    /// Returns a new Path by removing the specified Path off the beginning
    /// If the second path is not a prefix of the first nothing happens
    public func removingPrefix(_ path: Path) -> Path {
        guard hasPrefix(path) else {
            return self
        }
        let string = self.path.dropFirst(path.path.count)
        if string.first == Character(delimiter) {
            return Path(string.dropFirst())
        }
        return Path(string)
    }

    /// Returns a new Path by removing the specified Path off the end
    /// If the second path is not a suffix of the first nothing happens
    public func removingSuffix(_ path: Path) -> Path {
        guard hasSuffix(path) else {
            return self
        }
        let string = self.path.dropLast(path.path.count)
        if string.count > 1, string.last == Character(delimiter) {
            return Path(string.dropLast())
        }
        return Path(string)
    }

}

// MARK: - Sequence

extension Path: Sequence {
    public func makeIterator() -> IndexingIterator<[String]> {
        components.makeIterator()
    }
}

// MARK: - Collection

extension Path: Collection {
    public var startIndex: Int {
        components.startIndex
    }

    public var endIndex: Int {
        components.endIndex
    }

    public subscript(position: Int) -> String {
        components[position]
    }

    public func index(after i: Int) -> Int {
        components.index(after: i)
    }
}

// MARK: - Expressible By String Literal

extension Path: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(_ path: Path) {
        appendInterpolation(path.string)
    }
}

// MARK: - Custom String Convertible

extension Path: CustomStringConvertible {
    public var description: String {
        string
    }
}

// MARK: - Codable

extension Path: Codable {
    public func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }

    public init(from decoder: Swift.Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self.init(string)
    }
}


// MARK: - Vapor Compatibility

extension Path {

    /// Returns an array of Vapor `PathComponent`s
    var pathComponents: [PathComponent] {
        components.map {
            PathComponent(stringLiteral: $0)
        }
    }

}
