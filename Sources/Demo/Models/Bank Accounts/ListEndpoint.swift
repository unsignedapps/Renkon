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

extension BankAccounts {

    /// The main account listing endpoint
    static let list = JSONEndpoint(
        path: "/accounts",
        method: .GET,
        description: "Retrieves the list of available bank accounts for the logged in user.",
        requestType: Empty.self,
        responseType: [BankAccount].self
    ) {

        StaticResponse(
            id: "zero-balance",
            content: [
                BankAccount(name: "Annabelle Citizen", bsb: "000123", number: "123456789", balance: 0),
            ]
        )

        StaticResponse(
            id: "millionaire",
            content: [
                BankAccount(name: "Annabelle Citizen", bsb: "000123", number: "123456789", balance: 1_000_000),
            ]
        )

    }

}
