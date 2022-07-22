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

final class ScenarioMiddleware {

    static let headerName = "x-renkon-scenario"


    // MARK: - Properties

    /// The loaded scenarios that we can choose from
    private(set) var scenarios: [Scenario.Identifier: Scenario] = [:]

    /// The default scenario to use if one is not specified
    private var defaultScenario: Scenario?


    // MARK: - Initialisation

    init() {
        // Intentionally left blank
    }


    // MARK: - Scenario Management

    /// Adds a scenario to the internal list
    func add(_ scenario: Scenario) {
        scenarios[scenario.id] = scenario
    }

    /// Removes a scenario from the internal list
    func remove(_ identifier: Scenario.Identifier) {
        scenarios.removeValue(forKey: identifier)
    }

    /// Set the default scenario for when the client does not specify one
    func setDefault(_ scenario: Scenario) {
        defaultScenario = scenario
    }

}


// MARK: - Middleware Conformance

extension ScenarioMiddleware: AsyncMiddleware {

    func respond(to request: Vapor.Request, chainingTo next: AsyncResponder) async throws -> Vapor.Response {
        if let scenarioHeader = request.headers.first(name: ScenarioMiddleware.headerName) {
            guard let scenario = scenarios[.init(scenarioHeader)] else {
                throw Abort(
                    .forbidden,
                    reason: "Selected Renkon Scenario '\(scenarioHeader)' does not exist or has not been loaded into the server."
                )
            }
            request.scenario = scenario

        } else if let defaultScenario {
            request.scenario = defaultScenario

        } else {
            throw Abort(
                .forbidden,
                reason: "Renkon Scenario header '\(ScenarioMiddleware.headerName)' is missing."
            )
        }
        return try await next.respond(to: request)
    }

}


// MARK: - Request Extensions

private enum ScenarioKey: StorageKey {
    typealias Value = Scenario
}

extension Vapor.Request {

    /// Access to the scenario associated with this Vapor Request
    var scenario: Scenario? {
        get { storage[ScenarioKey.self] }
        set { storage[ScenarioKey.self] = newValue }
    }

}
