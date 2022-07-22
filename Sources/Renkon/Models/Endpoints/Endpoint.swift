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

/// An Endpoint is used to represent an API that can be called by a client.
///
/// In a traditional HTTP server environment it encompasses both the "route" and
/// "endpoint" roles, in that it provides the label (path) used to reference this endpoint,
/// describes the request and response types, and keeps a list of the available response
/// templates that the user can use to build out the actions in the Scenario Builder.
///
public protocol Endpoint<Request, Response>: Identifiable {

    associatedtype Request: Renkon.Request
    associatedtype Response: Renkon.Response
    associatedtype RequestType: DecodableContentType
    associatedtype ResponseType: EncodableContentType

    typealias ResponseFactory = (Request, Context<Request, Response>) throws -> Response

    /// A unique identifier for this Endpoint, which is really just a combination of the
    /// HTTP method and path called
    var id: Identifier { get }
    typealias Identifier = Renkon.Identifier<RenkonNamespace.Endpoint>

    /// The Path that the endpoint is configured to react to. eg `/service/myendpoint`
    var path: Path { get }

    /// The HTTP Method that the endpoint is to configured to react to. eg `GET` or `POST`
    var method: HTTPMethod { get }

    /// A detailed description of the endpoint to be shown in the Scenario Builder
    var description: String { get }

    /// A list of the responses that are available for this Endpoint
    var responses: [Response.Identifier: ResponseFactory] { get }

    /// Implement this to create and return the appropriate request types for a given Vapor request
    func makeRequest(_ request: Vapor.Request) async throws -> Request

    /// Implement this to create and return the appropriate context type for a given Vapor request. Default implementation provided.
    func makeContext(_ request: Vapor.Request) async throws -> Context<Request, Response>

}


// MARK: - Default Implementation

public extension Endpoint {
    var id: Identifier {
        .init("\(method.rawValue)-\(path.string)")
    }

    func makeRequest(_ request: Vapor.Request) async throws -> Request {
        try await .decodeRequest(request)
    }

    func makeContext(_ request: Vapor.Request) async throws -> Context<Request, Response> {
        guard let scenario = request.scenario else {
            throw Abort(.internalServerError, reason: "Scenario was not found in the request context. Was the `ScenarioMiddleware` removed?")
        }
        return .init(endpoint: self, scenario: scenario, sessionId: request.sessionId, logger: request.logger)
    }
}


// MARK: - Helpers

extension Endpoint {
    func responseFactory(for responseId: Response.Identifier) -> ResponseFactory? {
        responses[responseId]
    }
}

extension Endpoint {

    /// Makes a Vapor `Route` for the receiver
    func makeRoute(actionTypes: [Action.Identifier: any Action.Type]) -> Route {
        .init(
            method: method,
            path: path.pathComponents,
            responder: ActionPipelineResponder(endpoint: self, actionTypes: actionTypes),
            requestType: Request.Content.self,
            responseType: Response.Content.self
        )
    }

}
