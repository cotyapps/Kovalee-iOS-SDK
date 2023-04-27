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
        .package(url: "https://github.com/adjust/ios_sdk", exact: "4.33.4"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", exact: "0.4.0"),
    ],
    targets: [
        .binaryTarget(
            name: "KovaleeFramework",
            path: "./Sources/KovaleeFramework.xcframework"
        ),
    ]
)
