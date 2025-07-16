// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useBundledFonts = false

let package = Package(
    name: "Zuper",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Zuper",targets: ["Zuper"]),
        .library(name: "ZuperStorybook", targets: ["ZuperStorybook"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.10.0"
        ),
        .package(
            url: "https://github.com/ordo-one/equatable.git",
            from: "1.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Zuper",
            resources: []
        ),
        .target(
            name: "ZuperStorybook",
            dependencies: ["Zuper"]
        ),
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "Zuper",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Equatable", package: "equatable")
            ]
        ),
    ]
)
