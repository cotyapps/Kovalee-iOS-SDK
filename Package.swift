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
        ),
		.library(
			name: "KovaleeAttribution",
			targets: [
				"KovaleeAttribution",
			]
		)
    ],
    dependencies: [
		.package(url: "https://github.com/adjust/ios_sdk", from: Version(4, 33, 5)),
		.package(url: "https://github.com/amplitude/Amplitude-Swift", from: Version(0, 4, 6))
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
				.product(name: "Amplitude-Swift", package: "Amplitude-swift")
			]
		),
		.target(
			name: "KovaleeAttribution",
			dependencies: [
				"KovaleeSDK",
				.product(name: "Adjust", package: "ios_sdk")
			]
		)
    ]
)
