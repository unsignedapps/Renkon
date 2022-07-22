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

/// A response with `Encodable` content that is encoded to JSON and sent back to a client
public struct JSONResponse<Content>: EncodableResponse where Content: Encodable {

    public typealias ContentType = Renkon.ContentType.JSON
    public typealias Encoder = JSONEncoder


    // MARK: - Metadata Properties

    /// A unique identifier for this response
    ///
    /// - Important: This identifier needs to be unique within an Endpoint.
    ///
    public var id: Response.Identifier

    /// The HTTP response status
    public var status: HTTPResponseStatus

    /// The header fields for this HTTP response.
    public var headers: HTTPHeaders

    /// The trailer fields for this HTTP response, if any.
    public var trailers: HTTPHeaders?


    // MARK: - Body Properties

    /// The main content or body of the response
    public var content: Content

    /// An instance of the encoder we can use to encode this response
    public var encoder: JSONEncoder


    // MARK: - Initialisation

    /// Memberwise initialiser for a ``JSONResponse``
    init(
        id: Response.Identifier,
        status: HTTPResponseStatus,
        headers: HTTPHeaders,
        trailers: HTTPHeaders? = nil,
        content: Content,
        encoder: JSONEncoder = .renkon
    ) {
        self.id = id
        self.status = status
        self.headers = headers
        self.trailers = trailers
        self.content = content
        self.encoder = encoder
    }

}
