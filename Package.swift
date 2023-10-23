// swift-tools-version: 5.5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KovaleeSDK",
	defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "KovaleeSDK",
            targets: [
                "KovaleeSDK",
            ]
        )
    ],
    dependencies: [
		.package(url: "https://github.com/amplitude/Amplitude-Swift", .exact("0.7.3"))
	],
    targets: [
        .binaryTarget(
            name: "KovaleeFramework",
            path: "./Frameworks/KovaleeFramework.xcframework"
        ),

		.target(
			name: "KovaleeSDK",
			dependencies: [
				"KovaleeFramework",
				.product(name: "AmplitudeSwift", package: "Amplitude-Swift")
			]
		)
    ]
)
