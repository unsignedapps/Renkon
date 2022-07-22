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

/// Describes an (Australian) Bank Account
///
public struct BankAccount: Codable {

    // MARK: - Properties

    /// The name on the account
    public let name: String

    /// The BSB (routing code)
    public let bsb: String

    /// The account number
    public let number: String

    /// The current balance of the account
    public let balance: Double


    // MARK: - Initialisation

    /// Memberwise initialiser for a Bank Account
    ///
    /// - Parameters:
    ///   - name: The name on the account
    ///   - bsb: The BSB (routing code)
    ///   - number: The account number
    ///   - balance: The current balance of the account
    ///
    public init(name: String, bsb: String, number: String, balance: Double) {
        self.name = name
        self.bsb = bsb
        self.number = number
        self.balance = balance
    }

}
