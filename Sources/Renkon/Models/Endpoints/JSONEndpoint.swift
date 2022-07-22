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
import Vapor

/// A `JSONEndpoint` is an endpoint that can be called by the client. It accepts JSON request bodies
/// and responds with JSON.
///
public struct JSONEndpoint<RequestContent, ResponseContent>: EncodableEndpoint where RequestContent: Decodable, ResponseContent: Encodable {

    public typealias Request = JSONRequest<RequestContent>
    public typealias RequestType = ContentType.JSON

    public typealias Response = JSONResponse<ResponseContent>
    public typealias ResponseType = ContentType.JSON

    public typealias Builder = ResponseBuilder<Request, Response, RequestContent, ResponseContent>


    // MARK: - Properties

    /// The Path that the endpoint is configured to react to. eg `/service/my-endpoint`
    public var path: Path

    /// The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    public var method: HTTPMethod

    /// A detailed description of the endpoint to be shown in the Scenario Builder
    public var description: String

    /// A list of the responses that are available for this Endpoint
    public var responses: [Response.Identifier: ResponseFactory]


    // MARK: - Encoding / Decoding

    /// The decoder that can be used to parse the request from the client.
    public var decoder: JSONDecoder

    /// The encoder that can be used to create the response to end back to the client.
    public var encoder: JSONEncoder


    // MARK: - Initialisation

    /// Memberwise initialiser for creating a JSON Endpoint
    ///
    /// - Parameters:
    ///   - path: The Path that the endpoint is configured to react to. eg `/service/myendpoint`
    ///   - method: The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    ///   - description: A detailed description of the endpoint to be shown in the Scenario Builder
    ///   - requestType: The type of the content provided by the requesting client.
    ///   - responseType: The type of the content that we're going to send back
    ///   - decoder: The decoder that can be used to parse the request from the client. Defaults to `.renkon`.
    ///   - encoder: The encoder that can be used to create the response to end back to the client. Defaults to `.renkon`.
    ///   - responses: A list of the responses that are available for this Endpoint
    ///
    public init(
        path: Path,
        method: HTTPMethod,
        description: String,
        requestType _: RequestContent.Type = RequestContent.self,
        responseType _: ResponseContent.Type = ResponseContent.self,
        decoder: JSONDecoder = .renkon,
        encoder: JSONEncoder = .renkon,
        responses: Builder...
    ) {
        self.path = path
        self.method = method
        self.description = description
        self.decoder = decoder
        self.encoder = encoder
        self.responses = Dictionary(uniqueKeysWithValues: responses.map { ($0.id, $0.responseFactory) })
    }


    /// Collection Builder-based initialiser for creating a JSON Endpoint
    ///
    /// - Parameters:
    ///   - path: The Path that the endpoint is configured to react to. eg `/service/myendpoint`
    ///   - method: The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    ///   - description: A detailed description of the endpoint to be shown in the Scenario Builder
    ///   - requestType: The type of the content provided by the requesting client.
    ///   - responseType: The type of the content that we're going to send back
    ///   - decoder: The decoder that can be used to parse the request from the client. Defaults to `.renkon`.
    ///   - encoder: The encoder that can be used to create the response to end back to the client. Defaults to `.renkon`.
    ///   - responses: A ResultBuilder that returns a list of ResponseBuilders
    ///
    public init(
        path: Path,
        method: HTTPMethod,
        description: String,
        requestType: RequestContent.Type = RequestContent.self,
        responseType: ResponseContent.Type = ResponseContent.self,
        decoder: JSONDecoder = .renkon,
        encoder: JSONEncoder = .renkon,
        @CollectionBuilder<Builder> responses: () -> [Builder]
    ) {
        self.path = path
        self.method = method
        self.description = description
        self.decoder = decoder
        self.encoder = encoder
        self.responses = Dictionary(uniqueKeysWithValues: responses().map { ($0.id, $0.responseFactory) })
    }
}

