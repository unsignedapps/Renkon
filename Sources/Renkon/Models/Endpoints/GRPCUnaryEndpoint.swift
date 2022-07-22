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
import SwiftProtobuf
import Vapor

/// A `GRPCEndpoint` is an endpoint that can be called by a gRPC client. It accepts
/// Protobuf request bodies and responds with JSON.
///
public struct GRPCUnaryEndpoint<Request, Response>: Endpoint
    where Request: Renkon.Request, Request.Content: Message, Response: Renkon.Response, Response.Content: Message
{

    public typealias RequestType = ContentType.Protobuf
    public typealias Request = Request

    public typealias ResponseType = ContentType.Protobuf
    public typealias Response = Response

    // MARK: - Properties

    /// The Path that the endpoint is configured to react to. eg `/service/myendpoint`
    public var path: Path

    /// The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    public var method: HTTPMethod

    /// A detailed description of the endpoint to be shown in the Scenario Builder
    public var description: String

    /// A list of the responses that are available for this Endpoint
    public var responses: [Response.Identifier: ResponseFactory]


    // MARK: - Initialisation

    /// Memberwise initialiser for creating a unary GRPC Endpoint
    ///
    /// - Parameters:
    ///   - path: The Path that the endpoint is configured to react to. eg `/service/myendpoint`
    ///   - method: The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    ///   - description: A detailed description of the endpoint to be shown in the Scenario Builder
    ///   - responses: A list of the responses that are available for this Endpoint
    ///
    public init(
        path: Path,
        method: HTTPMethod,
        description: String,
        responses: ResponseBuilder<Request, Response, Request.Content, Response.Content>...
    ) {
        self.path = path
        self.method = method
        self.description = description
        self.responses = Dictionary(uniqueKeysWithValues: responses.map { ($0.id, $0.responseFactory) })
    }

}
