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

/// A response that is encoded and sent back to a client
public protocol Response<Content>: AsyncResponseEncodable, Identifiable {

    associatedtype Content
    associatedtype ContentType: EncodableContentType
    typealias Identifier = Renkon.Identifier<RenkonNamespace.Response>

    // MARK: - Metadata Properties

    /// A unique identifier for this response
    ///
    /// - Important: This identifier needs to be unique within an Endpoint.
    ///
    var id: Identifier { get }

    /// The HTTP response status
    var status: HTTPResponseStatus { get }

    /// The header fields for this HTTP response.
    var headers: HTTPHeaders { get }

    /// The trailer fields for this HTTP response, if any.
    var trailers: HTTPHeaders? { get }


    // MARK: - Body Properties

    /// The main content of the response
    var content: Content { get }

    /// Convert the content into a ByteBuffer ready for sending
    func encodeContent(allocator: ByteBufferAllocator) throws -> ByteBuffer

}


// MARK: - Response Encodable Support

public extension Response {

    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let buffer = try encodeContent(allocator: request.byteBufferAllocator)
        let response = Vapor.Response(
            status: status,
            version: request.version,
            headers: headers,
            body: .init(buffer: buffer, byteBufferAllocator: request.byteBufferAllocator),
            trailers: trailers
        )

        if response.headers.contains(name: .contentType) == false {
            response.headers.add(name: .contentType, value: ContentType.canonicalContentType.canonicalValue)
        }

        return response
    }

}
