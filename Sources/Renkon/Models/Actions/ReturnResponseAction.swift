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

public struct ReturnResponseAction: Action {


    // MARK: - Properties

    /// A unique identifier for this namespace
    public static var id: Identifier<RenkonNamespace.Action> {
        .init("return-response")
    }

    /// The name of this action to show in the Scenario Builder
    public let displayName = "Returns a response to the client"

    /// A detailed description of the action that can be shown in the Scenario Builder
    public let description = "Returns the configured response immediately to the client."

    /// The identifier of the Response we need to return
    public let responseId: Response.Identifier


    // MARK: - Initialisation

    /// Creates an instance of the `RespondAction`
    public init(responseId: Response.Identifier) {
        self.responseId = responseId
    }

    public func perform<Request, Response>(request: Request, context: Context<Request, Response>) async throws -> Response?
        where Request: Renkon.Request, Response: Renkon.Response
    {
        guard let factory = context.endpoint.responseFactory(for: responseId) else {
            throw ReturnResponseError.configuredResponseDoesNotExistOnEndpoint(responseId, context.endpoint.id)
        }
        return try factory(request, context)
    }

}


// MARK: - Errors

extension ReturnResponseAction {
    enum ReturnResponseError: Error {
        case configuredResponseDoesNotExistOnEndpoint(Response.Identifier, Endpoint.Identifier)
    }
}


// MARK: - Configuration

public extension ReturnResponseAction {

    init(configuration: ActionConfiguration) throws {
        try configuration.confirm(id: Self.id)
        self.init(
            responseId: try configuration.unbox(for: .responseId)
        )
    }

    func makeConfiguration() -> ActionConfiguration {
        .init(id: Self.id) {
            $0.box(responseId, for: .responseId)
        }
    }

}

private extension ActionConfiguration.Key {
    static let responseId: Self = "response-id"
}
