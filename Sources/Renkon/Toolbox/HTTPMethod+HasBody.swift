//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import NIOHTTP1
import Vapor

// Some extensions that exist inside the HTTPMethod source.
extension HTTPMethod {

    enum HasBody: Equatable {
        case yes
        case no
        case unlikely
    }

    /// Whether requests with this verb may have a request body.
    var hasRequestBody: HasBody {
        switch self {
        case .TRACE:
            return .no
        case .POST, .PUT, .PATCH:
            return .yes
        case .GET, .CONNECT, .OPTIONS, .HEAD, .DELETE:
            fallthrough
        default:
            return .unlikely
        }
    }

}


// MARK: - Vapor Extension

extension Vapor.Request {
    var shouldDecodeBody: Bool {
        switch method.hasRequestBody {
        case .yes:              return true
        case .no:               return false
        case .unlikely:         return (body.data?.readableBytes ?? 0) > 0
        }
    }
}

