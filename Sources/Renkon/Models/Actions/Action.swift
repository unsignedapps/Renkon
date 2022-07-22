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

/// An `Action` is an chunk of code that is run in response to a request from a client
///
public protocol Action {

    typealias Identifier = Renkon.Identifier<RenkonNamespace.Action>


    // MARK: - Properties

    /// A unique identifier for this action
    static var id: Identifier { get }

    /// The name to show in the Scenario Builder
    var displayName: String { get }

    /// A detailed description of the action that can be shown in the Scenario Builder
    var description: String { get }

    /// A closure used to perform the Action.
    ///
    /// Your action should take whatever steps it believes are necessary in order to process the request, and can control
    /// the action pipeline processing depending on its return type.
    ///
    /// You have three options:
    ///   - If you return a `Response` then it will be returned immediately to the client
    ///   - If you throw an error then it will be returned to the client as well
    ///   - If you return `nil` the pipeline will move onto the next Action in the sequence
    ///
    /// - Parameters:
    ///   - request:        The request as received from the client
    ///   - context:        Additional information about the client and the request
    ///
    /// - Returns: Return `nil` to instruct the pipeline to move on to the next action, or a `Response` to send it back to the client
    /// - Throws: Any errors thrown will be returned to the client immediately/.
    ///
    func perform<Request, Response>(request: Request, context: Context<Request, Response>) async throws -> Response?
        where Request: Renkon.Request, Response: Renkon.Response


    // MARK: - Configuration

    /// Initialises the `Action` with a copy of its configuration
    init(configuration: ActionConfiguration) throws

    /// Creates a configuration instance for this Action so it can be serialised
    func makeConfiguration() -> ActionConfiguration

}
