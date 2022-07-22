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

import Renkon

public extension Scenario {

    static let broke = Scenario(
        id: "flat-broke",
        displayName: "Flat Broke",
        description: "Our demo customer is flat broke and is unable to make any payments or transfers.",
        endpoints: [
            BankAccounts.list.id: [
                ReturnResponseAction(responseId: "zero-balance"),
                ReturnResponseAction(responseId: "millionaire"),
            ],
        ]
    )

    static let rich = Scenario(
        id: "super-rich",
        displayName: "Super Rich",
        description: "Our demo customer has so much money they don't know what to do with it.",
        endpoints: [
            BankAccounts.list.id: [
                WaitAction(duration: .seconds(2)),
                ReturnResponseAction(responseId: "millionaire"),
            ],
        ]
    )

}
