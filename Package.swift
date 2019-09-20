// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import class Foundation.ProcessInfo

let shouldTest = ProcessInfo.processInfo.environment["TEST"] == "1"

func resolveDependencies() -> [Package.Dependency] {
    guard shouldTest else { return [] }

    return [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.0")),
    ]
}

func resolveTargets() -> [Target] {
    let baseTarget = Target.target(name: "SwiftyUserDefaults", dependencies: [], path: "Sources")
    let testTarget = Target.testTarget(name: "SwiftyUserDefaultsTests", dependencies: ["SwiftyUserDefaults", "Quick", "Nimble"])

    return shouldTest ? [baseTarget, testTarget] : [baseTarget]
}


let package = Package(
    name: "SwiftyUserDefaults",
    platforms: [
        .macOS(.v10_11), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "SwiftyUserDefaults", targets: ["SwiftyUserDefaults"]),
    ],
    dependencies: resolveDependencies(),
    targets: resolveTargets()
)
