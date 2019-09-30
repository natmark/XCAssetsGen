// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCAssetsGen",
    products: [
        .executable(name: "xcassetsgen", targets: ["XCAssetsGen"]),
        .library(name: "XCAssetsGenKit", targets: ["XCAssetsGenKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.1"),
        .package(url: "https://github.com/natmark/XCAssetsKit", from: "0.0.3"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "XCAssetsGen", dependencies: ["Commandant", "Curry", "XCAssetsGenKit"]),
        .target(name: "XCAssetsGenKit", dependencies: ["XCAssetsKit", "Yams"]),
        .testTarget(name: "XCAssetsGenTests", dependencies: ["XCAssetsGenKit"]),
    ]
)
