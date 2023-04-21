// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KovaleeSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "KovaleeSDK",
            targets: [
                "KovaleeFramework",
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/adjust/ios_sdk", branch: "master"),
    ],
    targets: [
        .binaryTarget(
            name: "KovaleeFramework",
            path: "./Sources/KovaleeFramework.xcframework"
        ),
    ]
)
