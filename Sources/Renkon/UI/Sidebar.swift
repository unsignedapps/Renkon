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

import SwiftUI

@available(iOS 16, macOS 13, *)
struct Sidebar: View {

    // MARK: - Properties

    @State private var searchTerm = ""
    @State private var selectedScenarioID: Scenario.Identifier?

    // MARK: - View conformance

    var body: some View {
        List(selection: $selectedScenarioID) {
            Section("Favorites") {
                NavigationLink("Scenario Name") {
                    ScenarioDetail()
                }
            }
            
            Section("All Scenarios") {
                NavigationLink("Scenario Name") {
                    ScenarioDetail()
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 280)
        .searchable(text: $searchTerm)
        .listStyle(.sidebar)
        .navigationDestination(for: Scenario.Identifier.self) {
            ScenarioDetail(scenarioID: $0)
        }
    }

}
