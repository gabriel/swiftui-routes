// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageB",
    platforms: [
        .iOS(.v17),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "PackageB",
            targets: ["PackageB"]
        ),
    ],
    dependencies: [
        .package(path: "../SwiftUIRoutes"),
    ],
    targets: [
        .target(
            name: "PackageB",
            dependencies: [
                .product(name: "SwiftUIRoutes", package: "SwiftUIRoutes"),
            ]
        ),
    ]
)
