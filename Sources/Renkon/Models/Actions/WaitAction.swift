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

/// An action that will suspend/sleep the current Task for the specified duration before returning `nil`, allowing
/// the action pipeline to continue on to the next action
///
public struct WaitAction: Action {

    // MARK: - Properties

    /// A unique identifier for this namespace
    public static var id: Identifier<RenkonNamespace.Action> {
        .init("wait")
    }

    /// The name of this action to show in the Scenario Builder
    public let displayName = "Wait for a period of time before continuing"

    /// A detailed description of the action that can be shown in the Scenario Builder
    public let description = "Waits for the configured duration before moving on to the next action."

    /// The  duration to wait
    public let duration: RenkonDuration

    // MARK: - Initialisation

    /// Creates an instance of the `WaitAction`
    ///
    /// - Parameters:
    ///   - duration:       The  duration to wait
    ///
    public init(duration: RenkonDuration) {
        self.duration = duration
    }


    // MARK: - Execution

    public func perform<Request, Response>(request _: Request, context _: Context<Request, Response>) async throws -> Response?
        where Request: Renkon.Request, Response: Renkon.Response
    {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            try await Task.sleep(until: .now + Duration(duration), clock: .continuous)
        } else {
            try await Task.sleep(nanoseconds: duration.nanoseconds)
        }
        return nil
    }

}


// MARK: - Configuration

public extension WaitAction {

    init(configuration: ActionConfiguration) throws {
        try configuration.confirm(id: Self.id)
        self.init(
            duration: .init(
                secondsComponent: try configuration.unbox(for: .seconds),
                attosecondsComponent: try configuration.unbox(for: .attoseconds)
            )
        )
    }

    func makeConfiguration() -> ActionConfiguration {
        .init(id: Self.id) {
            $0.box(duration.components.seconds, for: .seconds)
            $0.box(duration.components.attoseconds, for: .attoseconds)
        }
    }

}

private extension ActionConfiguration.Key {
    static let seconds: Self = "duration.seconds"
    static let attoseconds: Self = "duration.attoseconds"
}

private extension RenkonDuration {

    var nanoseconds: UInt64 {
        UInt64(components.seconds * 1_000_000_000) + UInt64(components.attoseconds / 1_000_000_000)
    }

}
