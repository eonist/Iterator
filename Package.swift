// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Iterator",
    products: [
        .library(
            name: "Iterator",
            targets: ["Iterator"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Iterator",
            dependencies: []),
        .testTarget(
            name: "IteratorTests",
            dependencies: ["Iterator"])
    ]
)
