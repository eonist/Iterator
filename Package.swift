// swift-tools-version:5.9
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
