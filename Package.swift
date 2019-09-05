// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyUserDefaults",
    platforms: [
        .macOS(.v10_11), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "SwiftyUserDefaults",
            targets: ["SwiftyUserDefaults"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.0")),
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
