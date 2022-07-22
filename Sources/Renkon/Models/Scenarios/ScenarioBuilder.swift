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

public protocol ScenarioBuilder {

    /// Adds the provided ``Scenario`` to the server. If a Scenario with the same identifier already
    /// exists it will be replaced.
    mutating func addScenario(_ scenario: Scenario)

    /// Adds the provided Scenarios to the server. If any of the provided Scenarios already exist they
    /// will be replaced.
    mutating func addScenarios(@CollectionBuilder<Scenario> _ makeScenarios: () -> [Scenario])

    /// Removes the Scenario with the provided identifier
    mutating func removeScenario(_ scenario: Scenario.Identifier)

    /// Sets the default Scenario that will be used if the client does not specify one.
    mutating func setDefaultScenario(_ scenario: Scenario)

}
