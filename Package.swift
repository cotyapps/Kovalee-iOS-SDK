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
    dependencies: [
		.package(url: "https://github.com/adjust/ios_sdk", exact: "4.33.4"),
		.package(url: "https://github.com/amplitude/Amplitude-Swift", exact: "0.4.6"),
		.package(url: "https://github.com/RevenueCat/purchases-ios", exact: "4.18.0"),
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.11.0")
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
				.product(name: "Adjust", package: "ios_sdk"),
				.product(name: "Amplitude-Swift", package: "Amplitude-swift"),
				.product(name: "RevenueCat", package: "purchases-ios"),
				.product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
				.product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
			]
		)
    ]
)
