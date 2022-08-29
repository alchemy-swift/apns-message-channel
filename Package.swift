// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "apns-message-channel",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "APNSMessageChannel", targets: ["APNSMessageChannel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alchemy-swift/alchemy", branch: "main"),
        .package(url: "https://github.com/kylebrowning/APNSwift.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "APNSMessageChannel",
            dependencies: [
                .product(name: "Alchemy", package: "alchemy"),
                .product(name: "APNSwift", package: "APNSwift"),
            ]),
    ]
)
