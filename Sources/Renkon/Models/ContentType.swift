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

/// Supported / known Content Types
/// See:
/// - https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md
/// - https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md
///
public enum ContentType {

    // MARK: - Cases

    case json
    case protobuf
    case webProtobuf
    case webTextProtobuf


    // MARK: - Initialisation

    /// Initialises a ``ContentType`` by looking up the provided string value against known
    /// Content-Type header values.
    ///
    public init?(value: String) {
        guard let mapped = Self.mapping[value] else {
            return nil
        }
        self = mapped
    }


    // MARK: - Mappings

    /// Known Content-Type header values and their corresponding ``ContentType`` case.
    static var mapping: [String: ContentType] {
        [
            // JSON
            "application/json":                 .json,
            "text/json":                        .json,

            // Straight gRPC
            "application/grpc":                 .protobuf,
            "application/grpc+proto":           .protobuf,

            // gRPC + Web (HTTP/1.1)
            "application/grpc-web":             .webProtobuf,
            "application/grpc-web+proto":       .webProtobuf,

            // Text gRPC + Web
            "application/grpc-web-text":        .webTextProtobuf,
            "application/grpc-web-text+proto":  .webTextProtobuf,
        ]
    }

    /// The canonical Content-Type header value for this  ``ContentType``
    public var canonicalValue: String {
        switch self {
        case .json:                 return "application/json"
        case .protobuf:             return "application/grpc"
        case .webProtobuf:          return "application/grpc-web+proto"
        case .webTextProtobuf:      return "application/grpc-web-text+proto"
        }
    }

}


// MARK: - Generics

public extension ContentType {

    /// A type used by the encoding/decoding system to ensure you are only able to
    /// use encoders/decoders that support JSON with JSON endpoints/responses.
    enum JSON: DecodableContentType & EncodableContentType {
        public static let canonicalContentType = ContentType.json
        public static let supportedContentTypes: [ContentType] = [
            .json,
        ]
    }

    /// A type used by the encoding/decoding system to ensure that you are only able to
    /// use encoders/decoders that support JSON with JSON endpoints/responses.
    enum Protobuf: DecodableContentType & EncodableContentType {
        public static let canonicalContentType = ContentType.protobuf
        public static let supportedContentTypes: [ContentType] = [
            .protobuf,
            .webProtobuf,
            .webTextProtobuf,
        ]
    }

}
