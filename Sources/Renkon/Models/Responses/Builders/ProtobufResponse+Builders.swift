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

public extension ResponseBuilder where Request == ProtobufRequest<RequestContent>, Response == ProtobufResponse<ResponseContent> {

    /// Ignores the request from the client and returns a fixed/static  ``Response`` that is encoded as binary Protobuf.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this response. This identifier MUST be unique within the Endpoint.
    ///   - grpcStatus: The GRPC response status
    ///   - headers: The header fields for this HTTP response.
    ///   - trailers: The trailer fields for this HTTP response, if any.
    ///   - content: The main content or body of the response
    ///
    static func `static`(
        id: Response.Identifier,
        grpcStatus: GRPCStatus,
        headers: HTTPHeaders,
        trailers: HTTPHeaders? = nil,
        content: ResponseContent
    ) -> Self {
        .init(id: id) { _, _ in
            ProtobufResponse(id: id, grpcStatus: grpcStatus, headers: headers, trailers: trailers, content: content)
        }
    }

    /// A Response that accepts a closure, allowing you to build a Response dynamically based on what was received from the client.
    ///
    /// The response is serialised into binary Protobuf.
    ///
    /// Your closure will be passed the ``ProtobufRequest`` and some ``Context``, and should return a fully formed
    /// ``ProtobufResponse``. You can throw errors that abort processing such as `Abort` to return errors back to the client.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this response. This identifier MUST be unique within the Endpoint.
    ///   - makeResponse: A closure that is passed in the ``ProtobufRequest`` received from the client and must return a ``ProtobufResponse``
    ///
    static func dynamic(
        id: Response.Identifier,
        makeResponse: @escaping (Request, Context<Request, Response>) throws -> Response
    ) -> Self {
        .init(id: id, responseFactory: makeResponse)
    }

}
