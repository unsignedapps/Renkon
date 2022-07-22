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

struct SessionMiddleware {

    static let sessionHeader = "x-renkon-session"


    // MARK: - Initialisation

    init() {
        // Intentionally left blank
    }

}


// MARK: - Middleware Conformance

extension SessionMiddleware: AsyncMiddleware {

    func respond(to request: Vapor.Request, chainingTo next: AsyncResponder) async throws -> Vapor.Response {
        let sessionHeader = request.headers.first(name: SessionMiddleware.sessionHeader) ?? UUID().uuidString
        request.sessionId = .init(sessionHeader)
        return try await next.respond(to: request)
    }

}


// MARK: - Request Extensions

public typealias SessionIdentifier = Identifier<RenkonNamespace.Session>

private enum SessionKey: StorageKey {
    typealias Value = SessionIdentifier
}

extension Vapor.Request {

    /// Access to the session identifier associated with this Vapor Request
    var sessionId: SessionIdentifier {
        get { storage[SessionKey.self] ?? .init(UUID().uuidString) }
        set { storage[SessionKey.self] = newValue }
    }

}
