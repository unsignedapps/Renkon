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

public struct ResponseBuilder<Request, Response, RequestContent, ResponseContent>
    where Request: Renkon.Request, Request.Content == RequestContent, Response: Renkon.Response, Response.Content == ResponseContent
{

    // MARK: - Properties

    /// The unique identifier for the response this builder will create
    ///
    /// - Important: This identifier needs to be unique within an Endpoint.
    ///
    var id: Response.Identifier

    /// The factory method that will create the response
    var responseFactory: (Request, Context<Request, Response>) throws -> Response

}

