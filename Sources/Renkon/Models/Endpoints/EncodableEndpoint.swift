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

import Vapor

/// An Endpoint is used to represent an API that can be called by a client that has
/// Codable request and response bodies.
public protocol EncodableEndpoint<Request, Response>: Endpoint where Request.Content: Decodable, Response.Content: Encodable {

    /// The decoder that can be used to parse the request from the client.
    associatedtype Decoder: RequestDecoder where Decoder.Input == RequestType

    /// The encoder that can be used to create the response to end back to the client.
    associatedtype Encoder: ResponseEncoder where Encoder.Output == ResponseType

    /// The decoder that can be used to parse the request from the client.
    var decoder: Decoder { get }

    /// The encoder that can be used to create the response to end back to the client.
    var encoder: Encoder { get }

}


// MARK: - Default Implementations

public extension EncodableEndpoint {
    func makeRequest(_ request: Vapor.Request) async throws -> Request {
        request.decoder = decoder
        return try await .decodeRequest(request)
    }
}
