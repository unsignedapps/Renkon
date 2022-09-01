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

/// A scene to display a Renkon UI.
///
/// - Note: This is currently a scene, but we may consider shifting to a simple view if we don't need any
///   enforced windowing behaviours.
///
@available(iOS 16, macOS 13, *)
public struct RenkonScene: Scene {

    // MARK: - Properties

    private var title: Text
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    // MARK: - Public initializers

    public init(title: LocalizedStringKey) {
        self.title = Text(title)
    }

    public init(title: String) {
        self.title = Text(title)
    }

    // MARK: - Scene conformance

    public var body: some Scene {
        WindowGroup(title) {
            NavigationSplitView(
                columnVisibility: $columnVisibility,
                sidebar: {
                    Sidebar()
                        .navigationTitle(title)
                },
                content: {
                    ScenarioDetail()
                },
                detail: {
                    EndpointDetail()
                }
            )
        }
    }

}
