import Foundation
import Danger
let danger = Danger()

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })
let isTrivial = danger.github.pullRequest.title.contains("#trivial")

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10 {
    warn("Big PR, try to keep changes smaller if you can")
}

if !isTrivial && !changelogChanged && sourceChanges != nil {
    warn("""
     Any changes to library code should be reflected in the Changelog.
    """)
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

let onlyPodspec = allSourceFiles.contains("SwiftyUserDefaults.podspec") && !allSourceFiles.contains("Package.swift")
let onlyPackage = !allSourceFiles.contains("SwiftyUserDefaults.podspec") && allSourceFiles.contains("Package.swift")
if onlyPodspec != onlyPackage {
    warn("Only one of either the podspec or SPM package was changed. This might be unintentional – double check.")
}

// Workaround for SwiftLint bug https://github.com/ashfurrow/danger-swiftlint/issues/4
SwiftLint.lint(inline: true, directory: "Sources", configFile: ".swiftlint.yml")
SwiftLint.lint(inline: true, directory: "Tests", configFile: "Tests/SwiftyUserDefaultsTests/.swiftlint.yml")
