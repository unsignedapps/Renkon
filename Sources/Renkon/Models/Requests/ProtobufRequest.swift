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
import SwiftProtobuf
import Vapor

/// A request from the client with a Protobuf payload.
public struct ProtobufRequest<Content>: Request where Content: Message {

    public typealias ContentType = Renkon.ContentType.Protobuf


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
        url: URI,
        path: Path,
        headers: HTTPHeaders,
        content: Content,
        trailers: HTTPHeaders? = nil
    ) {
        self.version = version
        self.method = .POST         // gRPC spec only allows for POST requests
        self.url = url
        self.path = path
        self.headers = headers
        self.content = content
        self.trailers = trailers
    }


    // MARK: - Decoding Requests

    /// Implements `AsyncDecodableRequest/decodeRequest(_:)`
    public static func decodeRequest(_ request: Vapor.Request) async throws -> ProtobufRequest<Content> {
        let content: Content
        if let buffer = request.body.data, let data = buffer.getData(at: buffer.readerIndex, length: buffer.readableBytes) {
            content = try Content(serializedData: data)
        } else {
            content = .init()
        }

        let protobufRequest = ProtobufRequest(
            version: request.version,
            url: request.url,
            path: .init(request.url.path),
            headers: request.headers,
            content: content,
            trailers: nil
        )
        return protobufRequest
    }

}
