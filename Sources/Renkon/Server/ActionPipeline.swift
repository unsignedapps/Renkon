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

actor ActionPipeline<Request, Response> where Request: Renkon.Request, Response: Renkon.Response {

    // MARK: - Properties

    /// The session identifier associated with this pipeline
    private let sessionId: SessionIdentifier

    /// The list of actions we should be executing
    private let configuredActions: [ActionConfiguration]

    /// The actions that this server is configured with, that we can use to process responses
    private let availableActionTypes: [Action.Identifier: any Action.Type]

    /// The index of the most recently run action
    private var currentIndex: Array<ActionConfiguration>.Index


    // MARK: - Initialisation

    /// Memberwise initialiser
    init(
        sessionId: SessionIdentifier,
        actions: [ActionConfiguration],
        actionTypes: [Action.Identifier: any Action.Type]
    ) {
        self.sessionId = sessionId
        self.configuredActions = actions
        self.availableActionTypes = actionTypes
        self.currentIndex = actions.endIndex            // this will immediately wrap to the beginning
    }


    // MARK: - Compatibility

    /// This method compares the supplied configurations against our pre-configured ones.
    ///
    /// If a Scenario's actions are changed while the server is running the provided action configurations
    /// will be different to what we're configured with, and that means this pipeline is no longer valid.
    ///
    func isCompatible(with actions: [ActionConfiguration]) -> Bool {
        configuredActions == actions
    }


    // MARK: - Handler

    func handle(_ request: Request, context: Context<Request, Response>) async throws -> Response {

        // this is our failsafe to prevent infinite loops. If we go through the entire `configuredActions`
        // array and no one throws or returns a non-nil value then we bail out
        let startedIndex = currentIndex
        repeat {
            let action = try nextAction()
            if let response = try await action.perform(request: request, context: context) {
                return response
            }
        } while startedIndex != currentIndex

        throw Abort(
            .internalServerError,
            reason: "Action pipeline looped through all configured actions and no one returned a response. Aborting to prevent an infinite loop."
        )
    }

    func nextAction() throws -> any Action {
        guard configuredActions.isEmpty == false else {
            throw Abort(.notFound, reason: "No actions were configured in the selected scenario for this endpoint.")
        }

        let next = currentIndex.advanced(by: 1)
        if next >= configuredActions.endIndex {
            currentIndex = configuredActions.startIndex
        } else {
            currentIndex = next
        }

        let configuration = configuredActions[currentIndex]
        guard let type = availableActionTypes[configuration.id] else {
            throw Abort(.internalServerError, reason: "Configured action '\(configuration.id)' does not exist in list of available actions.")
        }

        return try type.init(configuration: configuration)
    }

}
