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

public struct Server: EndpointBuilder, ScenarioBuilder {

    // MARK: - Properties

    /// All of the available endpoints that are configured on this ``Server``
    public private(set) var endpoints: [Endpoint.Identifier: any Endpoint] = [:]

    /// All of the available actions that are configured on this ``Server``
    public private(set) var actions: [Action.Identifier: any Action.Type] = Self.defaultActions

    /// All of the available scenarios that are configured on this ``Server``
    public var scenarios: [Scenario.Identifier: Scenario] { scenarioMiddleware.scenarios }

    /// The internal Vapor application that does all of the actual work
    public private(set) var app: Application

    /// Whether or not the server is currently running
    public var isRunning = false


    // MARK: - Middleware

    /// The scenario detection / management middleware
    private var scenarioMiddleware = ScenarioMiddleware()

    /// The session detection middleware
    private let sessionMiddleware = SessionMiddleware()


    // MARK: - Initialisation

    public init(hostname: String = "127.0.0.1", port: Int = 8080) {
        self.app = Application()
        app.http.server.configuration.hostname = hostname
        app.http.server.configuration.port = port
        app.logger.logLevel = .debug

        app.middleware.use(scenarioMiddleware)
        app.middleware.use(sessionMiddleware)
    }


    // MARK: - Running

    public mutating func run() throws {
        isRunning = true
        defer { isRunning = false }
        try setupEndpoints()
        try app.run()
    }

    private func setupEndpoints() throws {
        app.routes.all.removeAll(keepingCapacity: true)
        for endpoint in endpoints.values {
            app.add(endpoint.makeRoute(actionTypes: actions))
        }
    }


    // MARK: - Managing Endpoints

    /// Adds the provided ``Endpoint`` to the server. If an Endpoint with the same identifier already
    /// exists it will be replaced.
    public mutating func addEndpoint(_ endpoint: any Endpoint) throws {
        guard isRunning == false else {
            throw ServerError.cannotAddEndpointsWhileServerIsRunning
        }
        endpoints[endpoint.id] = endpoint
    }

    /// Adds the provided Endpoints to the server. If any of the provided Endpoints already exist they
    /// will be replaced.
    public mutating func addEndpoints(@CollectionBuilder<any Endpoint> _ makeEndpoints: () -> [any Endpoint]) throws {
        for endpoint in makeEndpoints() {
            try addEndpoint(endpoint)
        }
    }


    // MARK: - Managing Actions

    /// Adds the provided ``Action`` to the server. If an Action with the same identifier already
    /// exists it will be replaced.
    public mutating func addAction(_ action: any Action.Type) throws {
        guard isRunning == false else {
            throw ServerError.cannotAddActionsWhileServerIsRunning
        }
        actions[action.id] = action
    }

    /// Adds the provided Actions to the server. If any of the provided Actions already exist they
    /// will be replaced.
    public mutating func addActions(@CollectionBuilder<any Action.Type> _ makeActions: () -> [any Action.Type]) throws {
        for action in makeActions() {
            try addAction(action)
        }
    }


    // MARK: - Managing Scenarios

    /// Adds the provided ``Scenario`` to the server. If a Scenario with the same identifier already
    /// exists it will be replaced.
    public mutating func addScenario(_ scenario: Scenario) {
        scenarioMiddleware.add(scenario)
    }

    /// Adds the provided Scenarios to the server. If any of the provided Scenarios already exist they
    /// will be replaced.
    public mutating func addScenarios(@CollectionBuilder<Scenario> _ makeScenarios: () -> [Scenario]) {
        for scenario in makeScenarios() {
            addScenario(scenario)
        }
    }

    /// Removes the Scenario with the provided identifier
    public mutating func removeScenario(_ scenario: Scenario.Identifier) {
        scenarioMiddleware.remove(scenario)
    }

    /// Sets the default Scenario that will be used if the client does not specify one.
    public mutating func setDefaultScenario(_ scenario: Scenario) {
        scenarioMiddleware.setDefault(scenario)
    }

}


// MARK: - Errors

enum ServerError: Error {
    case cannotAddEndpointsWhileServerIsRunning
    case cannotAddActionsWhileServerIsRunning
}
