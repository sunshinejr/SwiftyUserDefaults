// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import class Foundation.ProcessInfo

let shouldTest = ProcessInfo.processInfo.environment["TEST"] == "1"

func resolveDependencies() -> [Package.Dependency] {
    guard shouldTest else { return [] }

    return [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "7.1.0"))
    ]
}

func resolveTargets() -> [Target] {
    let baseTarget = Target.target(name: "SwiftyUserDefaults", dependencies: [], path: "Sources")
    let testTarget = Target.testTarget(name: "SwiftyUserDefaultsTests", dependencies: ["SwiftyUserDefaults", "Quick", "Nimble"])

    return shouldTest ? [baseTarget, testTarget] : [baseTarget]
}


let package = Package(
    name: "SwiftyUserDefaults",
    products: [
        .library(
            name: "SwiftyUserDefaults",
            targets: ["SwiftyUserDefaults"]),
    ],
    dependencies: resolveDependencies(),
    targets: resolveTargets(),
    swiftLanguageVersions: [.v4_2]
)
