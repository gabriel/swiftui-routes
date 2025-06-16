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
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIRoutes",
            dependencies: [],
            path: "Sources"
        )
    ]
)
