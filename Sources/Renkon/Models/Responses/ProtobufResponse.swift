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

import GRPC
import NIOCore
import SwiftProtobuf
import Vapor

/// A response with Protobuf content that is to be sent back to a client
public struct ProtobufResponse<Content>: Response where Content: Message {

    public typealias ContentType = Renkon.ContentType.Protobuf

    // MARK: - Metadata Properties

    /// A unique identifier for this response
    ///
    /// - Important: This identifier needs to be unique within an Endpoint.
    ///
    public var id: Response.Identifier

    /// The HTTP response status
    public let status: HTTPResponseStatus = .ok

    /// The GRPC response status
    public var grpcStatus: GRPCStatus

    /// The header fields for this HTTP response.
    public var headers: HTTPHeaders

    /// The trailer fields for this HTTP response, if any.
    public var trailers: HTTPHeaders?


    // MARK: - Body Properties

    /// The main content of the response
    public var content: Content


    // MARK: - Initialisation

    /// Memberwise initialiser for a ``JSONResponse``
    init(
        id: Response.Identifier,
        grpcStatus: GRPCStatus,
        headers: HTTPHeaders,
        trailers: HTTPHeaders? = nil,
        content: Content
    ) {
        self.id = id
        self.grpcStatus = grpcStatus
        self.headers = headers
        self.trailers = trailers
        self.content = content
    }

}


// MARK: - Response Encoding

public extension ProtobufResponse {

    func encodeContent(allocator: ByteBufferAllocator) throws -> ByteBuffer {
        try ProtobufSerializer().serialize(content, allocator: allocator)
    }

}

