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

/// An internal replacement for Combine's `TopLevelDecoder`
public protocol RequestDecoder<Input>: ContentDecoder {

    /// The type this decoder accepts.
    associatedtype Input: DecodableContentType

}

/// A content-type that is able to be decoded
public protocol DecodableContentType {

    /// The content types we decode from
    static var supportedContentTypes: [ContentType] { get }

}
