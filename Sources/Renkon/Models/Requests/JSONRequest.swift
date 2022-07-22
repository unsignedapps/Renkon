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

import NIOCore
import Vapor

/// A request from the client with a JSON payload.
public struct JSONRequest<Content>: DecodableRequest where Content: Decodable {

    public typealias ContentType = Renkon.ContentType.JSON
    public typealias Decoder = JSONDecoder


    // MARK: - Metadata Properties

    /// The HTTP version that was used to connect to the server
    public let version: HTTPVersion

    /// The HTTP method that was called on the Endpoint
    public let method: HTTPMethod

    /// The full URL that was called by the client
    public let url: URI

    /// The Path that was called by the client
    public let path: Path

    /// Any headers that were received before the main content
    public let headers: HTTPHeaders

    /// The main content of the request
    public let content: Content

    /// Any trailers that were received after the main content
    public let trailers: HTTPHeaders?


    // MARK: - Initialisation

    internal init(
        version: HTTPVersion,
        method: HTTPMethod,
        url: URI,
        path: Path,
        headers: HTTPHeaders,
        content: Content,
        trailers: HTTPHeaders? = nil
    ) {
        self.version = version
        self.method = method
        self.url = url
        self.path = path
        self.headers = headers
        self.content = content
        self.trailers = trailers
    }


    // MARK: - Decoding Requests

    /// Implements `AsyncDecodableRequest/decodeRequest(_:)`
    public static func decodeRequest(_ request: Vapor.Request) async throws -> JSONRequest<Content> {
        JSONRequest(
            version: request.version,
            method: request.method,
            url: request.url,
            path: .init(request.url.path),
            headers: request.headers,
            content: try decodeContent(request),
            trailers: nil
        )
    }

    private static func decodeContent(_ request: Vapor.Request) throws -> Content {

        // if they have specified an empty body
        if Content.self == Empty.self {
            return Empty() as! Content
        }

        // what we do from here depends whether we expect to have a request body or not
        if request.shouldDecodeBody == false {
            let reason = request.method.hasRequestBody == .no ? "the HTTP Method does not support it" : "it is missing"
            throw Abort(.badRequest, reason: "Endpoint '\(request.method.rawValue) \(request.url.path)' requires a request body but \(reason).")
        }

        guard let decoder = request.decoder else {
            throw DecodingError.decoderUnavailable
        }
        return try request.content.decode(Content.self, using: decoder)
    }


    // MARK: - Errors

    enum DecodingError: Error, Equatable {
        case decoderUnavailable
    }

}
