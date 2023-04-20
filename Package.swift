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
                "KovaleeFramework"
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Local 
        .binaryTarget(
            name: "KovaleeFramework",
            path: "./Sources/KovaleeFramework.xcframework"
        )

        // .binaryTarget(
        //     name: "SomeRemoteBinaryPackage",
        //     url: "https://github.com/cotyapps/Kovalee-iOS-Framework/blob/master/distribution/KovaleeFramework.xcframework.zip",
        //     checksum: "The checksum of the ZIP archive that contains the XCFramework."
        // ),
    ]
)
