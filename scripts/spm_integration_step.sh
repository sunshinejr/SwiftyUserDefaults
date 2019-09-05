#!/bin/sh

SWIFT_VERSION=$1
PROJECT_NAME="TestSPM"
FRAMEWORK_NAME="SwiftyUserDefaults"

FRAMEWORK_DIR=$(pwd)
BRANCH_NAME=$(git symbolic-ref -q HEAD)
BRANCH_NAME=${BRANCH_NAME##refs/heads/}
BRANCH_NAME=${BRANCH_NAME:-HEAD}

mkdir $PROJECT_NAME
cd $PROJECT_NAME

swift package init
echo "// swift-tools-version:$SWIFT_VERSION

import PackageDescription

let package = Package(
    name: \"$PROJECT_NAME\",
    dependencies: [
        .package(url: \"$FRAMEWORK_DIR\", .branch(\"$BRANCH_NAME\")),
    ],
    targets: [
        .target(name: \"$PROJECT_NAME\", dependencies: [\"$FRAMEWORK_NAME\"]),
    ]
)
" > Package.swift
swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11"
cd ../
rm -rf $PROJECT_NAME