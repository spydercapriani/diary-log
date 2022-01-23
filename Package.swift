// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "diary-log",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "Diary",
            targets: [
                "Diary"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.0.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "Playground",
            dependencies: [
                "Diary"
            ]
        ),
        .target(
            name: "Diary",
            dependencies: [
                "diary-core"
            ]
        ),
        .target(
            name: "diary-core",
            dependencies: [
                "diary-utilities"
            ]
        ),
        .target(
            name: "diary-utilities",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "DiaryTests",
            dependencies: [
                "Diary"
            ]
        ),
    ]
)
