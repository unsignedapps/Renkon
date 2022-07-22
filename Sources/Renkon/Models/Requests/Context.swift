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

import Logging

/// Additional information associated with a request from a client
public struct Context<Request, Response> where Request: Renkon.Request, Response: Renkon.Response {

    // MARK: - Properties

    /// The endpoint that is handling this request
    public let endpoint: any Endpoint<Request, Response>

    /// The Scenario that is loaded
    public let scenario: Scenario

    /// A session identifier that can be used to tie multiple requests together using the `x-renkon-session` header.
    public let sessionId: SessionIdentifier

    /// A logger populated with metadata for the current request. Use this for debug logging.
    public let logger: Logger

}
