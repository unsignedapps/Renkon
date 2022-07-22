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

import Vapor

private enum DecoderKey: StorageKey {
    typealias Value = RequestDecoder
}

public extension Vapor.Request {

    /// The decoder we should be using to decode this request
    var decoder: (any RequestDecoder)? {
        get {
            storage[DecoderKey.self]
        }
        set {
            storage[DecoderKey.self] = newValue
        }
    }

}
