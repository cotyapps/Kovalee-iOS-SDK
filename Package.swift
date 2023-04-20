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
//                "Adjust",
//                "FrameworkWrapper"
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
//        .target(
//            name: "FrameworkWrapper",
//            dependencies: [
//                "KovaleeFramework",
////                "Adjust"
//                .product(name: "Adjust", package: "ios_sdk")
//            ]
////            path: "FrameworkWrapper"
//        ),
//        .binaryTarget(
//            name: "Adjust",
//            url: "https://github.com/adjust/ios_sdk/releases/download/v4.33.4/AdjustSdk-iOS-tvOS-Dynamic-4.33.4.xcframework.zip",
//            checksum: "67366734fdce1aee75fbcebe71379177e98ce1645dd1694d10a8f845815ab4f9"
//        )
    ]
)
