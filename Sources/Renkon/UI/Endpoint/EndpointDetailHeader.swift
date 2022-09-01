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
struct EndpointDetailHeader: View {
    
    // MARK: - Properties
    
    var endpointID: Endpoint.Identifier?
    
#if os(macOS)
    @Binding var editMode: Bool
#else
    @Environment(\.editMode) private var editMode
#endif
    
    @State private var description = "Description"
    
    // MARK: - View conformance
    
    var body: some View {
#if os(macOS)
        HStack(alignment: .top) {
            headerTextStack
            
            if isEditing {
                Button("Finish Editing") {
                    editMode = false
                }
            } else {
                Button("Edit") {
                    editMode = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
#else
        headerTextStack
#endif
    }
    
}

// MARK: - Private helpers

@available(iOS 16, macOS 13, *)
private extension EndpointDetailHeader {
    
    var headerTextStack: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("State")
                .fontWeight(titleWeight)
                .font(.callout)
                .foregroundStyle(.secondary)
            descriptionField
                .fontWeight(titleWeight)
            Text("/some.path.name.goes.here")
                .font(.callout)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var descriptionField: some View {
        if isEditing {
            TextField("Endpoint Description", text: $description)
                .textFieldStyle(.roundedBorder)
        } else {
            Text(description)
                .font(.title)
        }
    }
    
    var isEditing: Bool {
#if os(macOS)
        editMode
#else
        editMode?.wrappedValue.isEditing == true
#endif
    }

    var titleWeight: Font.Weight {
#if os(macOS)
        .bold
#else
        .semibold
#endif
    }
    
}
