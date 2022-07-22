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

// swiftlint:disable extension_access_modifier

import Foundation

/// A type that allows us to box up values so we can make them Codable more easily
///
public protocol RenkonValue {
    /// The type that this ``RenkonValue`` would be boxed into.
    ///
    /// For `Codable` support, a default boxed type of `Data` is assumed if you
    /// do not specify one directly.
    ///
    associatedtype BoxedValueType = Data

    /// When initialised with a ``BoxedRenkonValue`` your conforming type must
    /// be able to unbox and initialise itself. Return nil if you cannot successfully
    /// unbox the value, or if it is an incompatible type.
    ///
    init?(boxedValue: BoxedRenkonValue?)

    /// Your conforming type must return an instance of the ``BoxedRenkonValue``
    /// with the boxed type included. This type should match the type
    /// specified in the ``BoxedRenkonValue`` associated type.
    ///
    var boxedValue: BoxedRenkonValue { get }
}


// MARK: - Boxed Values

/// An intermediate type used to make encoding and decoding of types simpler.
///
/// Any custom type you conform to ``RenkonValue`` must be able to be represented using one of these types
///
public enum BoxedRenkonValue: Equatable {
    case array([BoxedRenkonValue])
    case bool(Bool)
    case dictionary([String: BoxedRenkonValue])
    case data(Data)
    case double(Double)
    case float(Float)
    case integer(Int)
    case none
    case string(String)
}


// MARK: - Conforming Simple Types

extension Bool: RenkonValue {
    public typealias BoxedValueType = Bool

    public init? (boxedValue: BoxedRenkonValue?) {
        switch boxedValue {
        case let .bool(value):          self = value
        case let .integer(value):       self = value != 0
        case let .float(value):         self = value != 0.0
        case let .double(value):        self = value != 0.0
        case let .string(value):        self = (value as NSString).boolValue
        default:                        return nil
        }
    }

    public var boxedValue: BoxedRenkonValue {
        .bool(self)
    }
}

extension String: RenkonValue {
    public typealias BoxedValueType = String

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .string(value) = boxedValue else {
            return nil
        }
        self = value
    }

    public var boxedValue: BoxedRenkonValue {
        .string(self)
    }
}

extension URL: RenkonValue {
    public typealias BoxedValueType = String

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .string(value) = boxedValue else {
            return nil
        }
        self.init(string: value)
    }

    public var boxedValue: BoxedRenkonValue {
        .string(absoluteString)
    }
}

extension Date: RenkonValue {
    public typealias BoxedValueType = String

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .string(value) = boxedValue else {
            return nil
        }

        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: value) else {
            return nil
        }

        self = date
    }

    public var boxedValue: BoxedRenkonValue {
        let formatter = ISO8601DateFormatter()
        return .string(formatter.string(from: self))
    }
}

extension Data: RenkonValue {
    public typealias BoxedValueType = Data

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .data(value) = boxedValue else {
            return nil
        }
        self = value
    }

    public var boxedValue: BoxedRenkonValue {
        .data(self)
    }
}

extension Double: RenkonValue {
    public typealias BoxedValueType = Double

    public init? (boxedValue: BoxedRenkonValue?) {
        switch boxedValue {
        case let .double(value):            self = value
        case let .float(value):             self = Double(value)
        case let .integer(value):           self = Double(value)
        case let .string(value):            self = (value as NSString).doubleValue
        default:                            return nil
        }
    }

    public var boxedValue: BoxedRenkonValue {
        .double(self)
    }
}

extension Float: RenkonValue {
    public typealias BoxedValueType = Float

    public init? (boxedValue: BoxedRenkonValue?) {
        switch boxedValue {
        case let .float(value):             self = value
        case let .double(value):            self = Float(value)
        case let .integer(value):           self = Float(value)
        case let .string(value):            self = (value as NSString).floatValue
        default:                            return nil
        }
    }

    public var boxedValue: BoxedRenkonValue {
        .float(self)
    }
}

extension Int: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        switch boxedValue {
        case let .integer(value):           self = value
        case let .string(value):            self = (value as NSString).integerValue
        default:                            return nil
        }
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(self)
    }
}

extension Int8: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = Int8(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension Int16: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = Int16(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension Int32: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = Int32(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension Int64: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = Int64(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension UInt: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = UInt(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension UInt8: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = UInt8(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension UInt16: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = UInt16(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension UInt32: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = UInt32(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}

extension UInt64: RenkonValue {
    public typealias BoxedValueType = Int

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let value = Int(boxedValue: boxedValue) else {
            return nil
        }
        self = UInt64(value)
    }

    public var boxedValue: BoxedRenkonValue {
        .integer(Int(self))
    }
}


// MARK: - Conforming Other Types

public extension RawRepresentable where Self: RenkonValue, RawValue: RenkonValue {
    typealias BoxedValueType = RawValue.BoxedValueType

    init? (boxedFlagValue: BoxedRenkonValue?) {
        guard let rawValue = RawValue(boxedValue: boxedFlagValue) else {
            return nil
        }
        self.init(rawValue: rawValue)
    }

    var boxedFlagValue: BoxedRenkonValue {
        rawValue.boxedValue
    }
}

extension Optional: RenkonValue where Wrapped: RenkonValue {
    public typealias BoxedValueType = Wrapped.BoxedValueType?

    public init? (boxedValue: BoxedRenkonValue?) {
        guard let boxedValue else {
            self = .none
            return
        }
        if case .none = boxedValue {
            self = .none

        } else if let wrapped = Wrapped(boxedValue: boxedValue) {
            self = wrapped

        } else {
            self = .none
        }
    }

    public var boxedValue: BoxedRenkonValue {
        self?.boxedValue ?? .none
    }
}

extension Array: RenkonValue where Element: RenkonValue {
    public typealias BoxedValueType = [Element.BoxedValueType]

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .array(array) = boxedValue else {
            return nil
        }
        self = array.compactMap { Element(boxedValue: $0) }
    }

    public var boxedValue: BoxedRenkonValue {
        .array(map(\.boxedValue))
    }
}

extension Dictionary: RenkonValue where Key == String, Value: RenkonValue {
    public typealias BoxedValueType = [String: Value.BoxedValueType]

    public init? (boxedValue: BoxedRenkonValue?) {
        guard case let .dictionary(dictionary) = boxedValue else {
            return nil
        }
        self = dictionary.compactMapValues { Value(boxedValue: $0) }
    }

    public var boxedValue: BoxedRenkonValue {
        .dictionary(mapValues { $0.boxedValue })
    }
}


// MARK: - Conforming Codable Types

public extension Decodable where Self: RenkonValue, Self: Encodable {
    init? (boxedFlagValue: BoxedRenkonValue?) {
        guard case let .data(data) = boxedFlagValue else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            self = try decoder.decode(Wrapper<Self>.self, from: data).wrapped

        } catch {
            assertionFailure("[Vexil] Unable to decode type \(String(describing: Self.self)): \(error))")
            return nil
        }
    }
}

public extension Encodable where Self: RenkonValue, Self: Decodable {
    var boxedFlagValue: BoxedRenkonValue {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return .data(try encoder.encode(Wrapper(wrapped: self)))

        } catch {
            assertionFailure("[Vexil] Unable to encode type \(String(describing: Self.self)): \(error)")
            return .data(Data())
        }
    }
}

// Because we can't encode/decode a JSON fragment in Swift 5.2 on Linux we wrap it in this.
internal struct Wrapper<Wrapped>: Codable where Wrapped: Codable {
    var wrapped: Wrapped
}
