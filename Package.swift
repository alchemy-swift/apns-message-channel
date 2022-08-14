// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "apns-notification-channel",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "apns-notification-channel", targets: ["apns-notification-channel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alchemy-swift/alchemy", branch: "main"),
    ],
    targets: [
        .target(
            name: "apns-notification-channel",
            dependencies: [
                .product(name: "Alchemy", package: "alchemy"),
            ]),
    ]
)
