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

import ArgumentParser
import Renkon

@main
struct RenkonDemo: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "renkon",
        abstract: "Renkon. An embeddable mock API server.",
        version: "0.0.1"
    )


    // MARK: - Options

    @Option(name: .shortAndLong, help: "The hostname/IP to bind on. Defaults to 127.0.0.1")
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong, help: "The port number to listen on. Defaults to 8080.")
    var port: Int = 8080


    // MARK: - Running

    func run() throws {

        var server = Server()
        try server.addEndpoints {
            BankAccounts.list
        }
        server.addScenarios {
            Scenario.broke
            Scenario.rich
        }
        try server.run()

    }

}
