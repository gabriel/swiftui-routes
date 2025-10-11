// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageA",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "PackageA",
            targets: ["PackageA"]
        )
    ],
    dependencies: [
        .package(name: "SwiftUIRoutes", path: "../..")
    ],
    targets: [
        .target(
            name: "PackageA",
            dependencies: [
                .product(name: "SwiftUIRoutes", package: "SwiftUIRoutes")
            ]
        )
    ]
)
