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

struct ScenarioEndpointRow: View {

    // MARK: - Properties

    var endpointID: Endpoint.Identifier?
    var isActive: Bool = true

    // MARK: - View conformance

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.green)
                .opacity(isActive ? 1 : 0)
            textContent
        }
        .padding(8)
    }

}

// MARK: - Private helpers

private extension ScenarioEndpointRow {

    var textContent: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Description")
                .font(.headline)
            Text("/some.path.name.goes.here")
                .font(.callout)
            Text("4 Actions")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}
