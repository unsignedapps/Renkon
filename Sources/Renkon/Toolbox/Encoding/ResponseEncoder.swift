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

import Foundation
import Vapor

/// An Internal replacement for Combine's `TopLevelEncoder`
public protocol ResponseEncoder<Output>: ContentEncoder {

    /// The type this encoder produces.
    associatedtype Output: EncodableContentType

}

/// A content-type that is able to be encoded
public protocol EncodableContentType {

    /// The content type we encode into
    static var canonicalContentType: ContentType { get }

}
