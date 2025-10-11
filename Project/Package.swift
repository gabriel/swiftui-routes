// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "Example",
            targets: ["Example"]
        )
    ],
    dependencies: [
        .package(path: ".."),
        .package(path: "PackageA"),
        .package(path: "PackageB")
    ],
    targets: [
        .target(
            name: "Example",
            dependencies: [
                .product(name: "SwiftUIRoutes", package: "swiftui-routes"),
                .product(name: "PackageA", package: "PackageA"),
                .product(name: "PackageB", package: "PackageB")
            ]
        )
    ]
)
