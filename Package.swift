// swift-tools-version: 5.7.1
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
                "KovaleeSDK",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "KovaleeSDK",
            path: "./Sources/KovaleeSDK.xcframework"
        ),
    ]
)
