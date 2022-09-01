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
struct EndpointDetail: View {

    // MARK: - Properties

    var endpointID: Endpoint.Identifier?
    var actions: [ActionConfiguration]?

#if os(macOS)
    @State private var editMode = false
#else
    @State private var editMode = EditMode.inactive
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif

    // MARK: - View conformance

    var body: some View {
        List {
            header

            Section("Actions") {
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.inset)
        .toolbar {
            secondaryToolbarItems
#if os(iOS)
            ToolbarItem(placement: .primaryAction) {
                EditButton()
            }
#endif
        }
#if os(iOS)
        .toolbar(showsBottomBar ? .visible : .hidden, for: .bottomBar)
        .navigationTitle("Endpoint")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(editMode == .active)
        .environment(\.editMode, $editMode)
#endif
    }

}

// MARK: - Private helpers

@available(iOS 16, macOS 13, *)
private extension EndpointDetail {

    var isEditing: Bool {
#if os(macOS)
        editMode
#else
        editMode.isEditing
#endif
    }

    var showsBottomBar: Bool {
#if os(macOS)
        false
#else
        horizontalSizeClass == .compact
#endif
    }

    var header: some View {
#if os(macOS)
        VStack() {
            EndpointDetailHeader(endpointID: endpointID, editMode: $editMode)
                .padding(.bottom)
            Divider()
        }
        .padding()
#else
        EndpointDetailHeader(endpointID: endpointID)
#endif
    }

    var secondaryToolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: secondaryToolbarItemPlacement) {
            Button(
                action: {
                    /* Intentionally Left Blank */
                },
                label: {
                    Label("Delay", systemImage: "clock")
                }
            )
            Button(
                action: {
                    /* Intentionally Left Blank */
                },
                label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            )
        }
    }

    private var secondaryToolbarItemPlacement: ToolbarItemPlacement {
#if os(iOS)
        if showsBottomBar {
            return .bottomBar
        }
#endif
        return .automatic
    }

}
