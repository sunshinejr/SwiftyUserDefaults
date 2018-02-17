// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyUserDefaults",
    products: [
        .library(
            name: "SwiftyUserDefaults",
            targets: ["SwiftyUserDefaults"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftyUserDefaults",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "SwiftyUserDefaultsTests",
            dependencies: ["SwiftyUserDefaults"]),
    ]
)
