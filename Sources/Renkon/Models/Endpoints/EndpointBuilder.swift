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

public protocol EndpointBuilder {

    /// Adds the provided ``Endpoint`` to the server. If an Endpoint with the same identifier already
    /// exists it will be replaced.
    mutating func addEndpoint(_ endpoint: any Endpoint) throws

    /// Adds the provided Endpoints to the server. If any of the provided Endpoints already exist they
    /// will be replaced.
    mutating func addEndpoints(@CollectionBuilder<any Endpoint> _ makeEndpoints: () -> [any Endpoint]) throws

}
