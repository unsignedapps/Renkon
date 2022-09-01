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
struct ScenarioDetail: View {

    // MARK: - Properties

    var scenarioID: Scenario.Identifier?

    @State private var selectedEndpointID: Endpoint.Identifier?

    // MARK: - View conformance

    var body: some View {
        List(selection: $selectedEndpointID) {
            Section("Group") {
                NavigationLink(
                    destination: {
                        EndpointDetail()
                    },
                    label: {
                        ScenarioEndpointRow()
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: {
                        /* Intentionally Left Blank */
                    },
                    label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                )
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 420)
        .navigationTitle("Scenario Name")
#if os(macOS)
        .navigationSubtitle("Scenario")
#else
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

}
