// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIRoutes",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftUIRoutes",
            targets: ["SwiftUIRoutes"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/gabriel/swiftui-snapshot-testing", from: "0.1.10")
    ],
    targets: [
        .target(
            name: "SwiftUIRoutes",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftUIRoutesTests",
            dependencies: [
                "SwiftUIRoutes",
                .product(name: "SwiftUISnapshotTesting", package: "swiftui-snapshot-testing")
            ],
            path: "Tests",
            exclude: ["__Snapshots__"]
        )
    ]
)
