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

/// A space that can be used with identifiers and other items requiring a safe namespace to avoid collisions
public enum RenkonNamespace {

    /// For items associated with ``Action``
    public enum Action {}

    /// For items associated with ``Endpoint``
    public enum Endpoint {}

    /// For items associated with ``Response``
    public enum Response {}

    /// For items associated with a ``Scenario``
    public enum Scenario {}

    /// For identifiers associated with a Session
    public enum Session {}

}
