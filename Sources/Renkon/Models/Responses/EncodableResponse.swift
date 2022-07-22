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
import NIOCore

/// A response with an `Encodable` content that is sent back to a client.
public protocol EncodableResponse<Content>: Response where Content: Encodable {

    associatedtype Encoder: ResponseEncoder where Encoder.Output == ContentType

    /// An instance of the `Encoder` we can use to encode the `Content` with
    var encoder: Encoder { get }

}


// MARK: - Body Encoding

public extension EncodableResponse {

    func encodeContent(allocator: ByteBufferAllocator) throws -> ByteBuffer {
        var buffer = allocator.buffer(capacity: 0)
        var headers = headers                           // we don't care that these aren't saved
        try encoder.encode(content, to: &buffer, headers: &headers)
        return buffer
    }

}
