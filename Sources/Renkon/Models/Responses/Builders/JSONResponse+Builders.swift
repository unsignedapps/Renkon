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

import Foundation
import NIOCore
import Vapor

/// Ignores the request from the client and returns a fixed/static  ``Response`` that is encoded as JSON.
///
/// - Parameters:
///   - id: A unique identifier for this response. This identifier MUST be unique within the Endpoint.
///   - status: The HTTP response status
///   - headers: The header fields for this HTTP response.
///   - trailers: The trailer fields for this HTTP response, if any.
///   - encoder: An instance of the encoder we can use to encode this response. Defaults to `.renkon`
///   - content: The main content or body of the response
///
public func StaticResponse<RequestContent: Decodable, ResponseContent: Encodable>(
    id: Response.Identifier,
    status: HTTPResponseStatus = .ok,
    headers: HTTPHeaders = [:],
    trailers: HTTPHeaders? = nil,
    requestType _: RequestContent.Type = RequestContent.self,
    encoder: JSONEncoder = .renkon,
    content: @autoclosure @escaping () -> ResponseContent
) -> ResponseBuilder<JSONRequest<RequestContent>, JSONResponse<ResponseContent>, RequestContent, ResponseContent> {
    .init(id: id) { _, _ in
        JSONResponse(id: id, status: status, headers: headers, trailers: trailers, content: content(), encoder: encoder)
    }
}

/// A Response that accepts a closure, allowing you to build a Response dynamically based on what was received from the client.
///
/// Your closure will be passed the ``JSONRequest`` and a ``Context`` and should return a fully
/// formed ``JSONResponse``. You can throw errors that abort processing such as `Abort` to return errors back to the client.
///
/// - Parameters:
///   - id: A unique identifier for this response. This identifier MUST be unique within the Endpoint.
///   - makeResponse: A closure that is passed in the ``JSONRequest`` received from the client and must return a ``JSONResponse``
///
public func DynamicResponse<RequestContent: Decodable, ResponseContent: Encodable>(
    id: Response.Identifier,
    makeResponse: @escaping (JSONRequest<RequestContent>, Context<JSONRequest<RequestContent>, JSONResponse<ResponseContent>>) throws -> JSONResponse<ResponseContent>
) -> ResponseBuilder<JSONRequest<RequestContent>, JSONResponse<ResponseContent>, RequestContent, ResponseContent> {
    .init(id: id, responseFactory: makeResponse)
}
