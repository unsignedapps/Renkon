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

/// A representation of the request that the client has sent us.
public protocol Request<Content>: AsyncRequestDecodable {

    /// The main (decoded) content of the request
    associatedtype Content

    /// The type of the content
    associatedtype ContentType: DecodableContentType


    // MARK: - Metadata Properties

    /// The HTTP version that was used to connect to the server
    var version: HTTPVersion { get }

    /// The HTTP method that was called on the Endpoint
    var method: HTTPMethod { get }

    /// The full URL that was called by the client
    var url: URI { get }

    /// The Path that was called by the client
    var path: Path { get }

    /// Any headers that were received before the main content
    var headers: HTTPHeaders { get }

    /// The main content of the request
    var content: Content { get }

    /// Any trailers that were received after the main content
    var trailers: HTTPHeaders? { get }

}
