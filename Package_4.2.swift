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
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "7.1.0"))
    ],
    targets: [
        .target(
            name: "SwiftyUserDefaults",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "SwiftyUserDefaultsTests",
            dependencies: ["SwiftyUserDefaults", "Quick", "Nimble"]),
    ]
)
