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

public extension Server {

    /// All of the actions that are available by default
    static let defaultActions: [Action.Identifier: any Action.Type] = [
        ReturnResponseAction.id:    ReturnResponseAction.self,
        WaitAction.id:              WaitAction.self,
    ]

}
