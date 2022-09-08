// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(

    // MARK: - Configuration

    name: "Renkon",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
    ],


    // MARK: - Products

    products: [
        .library(name: "Renkon", targets: ["Renkon"]),
        .library(name: "RenkonUI", targets: ["RenkonUI"]),
        .executable(name: "renkon-demo", targets: [ "Demo" ]),
    ],


    // MARK: - Dependencies

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.3"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.8.1"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.19.0"),
        .package(url: "https://github.com/unsignedapps/vapor.git", branch: "main"),
    ],

    targets: [


        // MARK: - Main Targets

        .target(
            name: "Renkon",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .testTarget(
            name: "RenkonTests",
            dependencies: [
                "Renkon",
            ]
        ),

        .target(
            name: "RenkonUI",
            dependencies: [
                .targetItem(name: "Renkon", condition: nil)
            ]
        ),


        // MARK: - Demo Server

        .executableTarget(
            name: "Demo",
            dependencies: [
                .target(name: "Renkon"),

                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)
