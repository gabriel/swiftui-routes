// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageC",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "PackageC",
            targets: ["PackageC"]
        )
    ],
    dependencies: [
        .package(path: "../SwiftUIRoutes")
    ],
    targets: [
        .target(
            name: "PackageC",
            dependencies: [
                .product(name: "SwiftUIRoutes", package: "SwiftUIRoutes")
            ]
        )
    ]
)
