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
import Vapor

actor ActionPipelineResponder<Endpoint>: AsyncResponder where Endpoint: Renkon.Endpoint {

    // MARK: - Properties

    /// The endpoint that is used to respond to the request
    private let endpoint: Endpoint

    /// Individual pipelines for this endpoint that are associated with individual sessions
    private var pipelines: [SessionIdentifier: ActionPipeline<Endpoint.Request, Endpoint.Response>] = [:]

    /// The list of available action types
    private let availableActionTypes: [Action.Identifier: any Action.Type]


    // MARK: - Initialisation

    /// Memberwise initialiser
    init(endpoint: Endpoint, actionTypes: [Action.Identifier: any Action.Type]) {
        self.endpoint = endpoint
        self.availableActionTypes = actionTypes
    }


    // MARK: - Async Responder Conformance

    func respond(to request: Vapor.Request) async throws -> Vapor.Response {
        let renkonRequest = try await endpoint.makeRequest(request)
        let context = try await endpoint.makeContext(request)

        guard let actions = context.scenario.endpoints[endpoint.id] else {
            throw Abort(
                .internalServerError,
                reason: "Endpoint '\(endpoint.method.rawValue) \(endpoint.path.string)' is not configured on Scenario '\(context.scenario.id.rawValue)'"
            )
        }

        let pipeline = await pipeline(for: context.sessionId, actions: actions)
        let response = try await pipeline.handle(renkonRequest, context: context)
        return try await response.encodeResponse(for: request)
    }


    // MARK: - Helpers

    private func pipeline(for sessionId: SessionIdentifier, actions: [ActionConfiguration]) async -> ActionPipeline<Endpoint.Request, Endpoint.Response> {
        if let pipeline = pipelines[sessionId], await pipeline.isCompatible(with: actions) {
            return pipeline
        }
        let pipeline = ActionPipeline<Endpoint.Request, Endpoint.Response>(
            sessionId: sessionId,
            actions: actions,
            actionTypes: availableActionTypes
        )
        pipelines[sessionId] = pipeline
        return pipeline
    }

}
