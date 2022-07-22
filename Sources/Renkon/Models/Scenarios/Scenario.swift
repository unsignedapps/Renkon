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

/// A ``Scenario`` is a description of all the endpoints available on the system and the configured actions.
///
/// A client can choose which scenario they wish to load, and then that scenario describes the actions each
/// ``Endpoint`` will take when the client calls it.
///
/// You can add your own custom Scenario options as required. See ``Scenario/Options-swift.struct``
///
public struct Scenario {


    // MARK: - Properties

    /// A unique identifier for this Scenario. This **must** be unique across Renkon
    public let id: Identifier
    public typealias Identifier = Renkon.Identifier<RenkonNamespace.Scenario>

    /// The display name to show in the Scenario Builder and login screen
    public let displayName: String

    /// A detailed description for this scenario to be shown in the Scenario Builder and login screen
    public let description: String

    /// Configuration options for this scenario
    public let options: Options

    /// The list of available Endpoints and their list of actions
    public let endpoints: Endpoints
    public typealias Endpoints = [Endpoint.Identifier: [ActionConfiguration]]


    // MARK: - Initialisation

    /// Creates a ``Scenario`` that tells the server which actions to execute in response to calls to which endpoints.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this Scenario. This **must** be unique across Renkon
    ///   - displayName: The display name to show in the Scenario Builder and login screen
    ///   - description: A detailed description for this scenario to be shown in the Scenario Builder and login screen
    ///   - options: Configuration options for this scenario
    ///   - endpoints: The list of available Endpoints and their configured actions
    ///
    public init(
        id: Scenario.Identifier,
        displayName: String,
        description: String,
        options: Scenario.Options = .init(),
        endpoints: Scenario.Endpoints
    ) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.options = options
        self.endpoints = endpoints
    }

    /// Creates a ``Scenario`` that tells the server which actions to execute in response to calls to which endpoints.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this Scenario. This **must** be unique across Renkon
    ///   - displayName: The display name to show in the Scenario Builder and login screen
    ///   - description: A detailed description for this scenario to be shown in the Scenario Builder and login screen
    ///   - options: Configuration options for this scenario
    ///   - endpoints: The list of available Endpoints and their list of actions
    ///
    public init(
        id: Scenario.Identifier,
        displayName: String,
        description: String,
        options: Scenario.Options = .init(),
        endpoints: [Endpoint.Identifier: [any Action]]
    ) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.options = options
        self.endpoints = endpoints.mapValues { $0.map { $0.makeConfiguration() } }
    }

}
