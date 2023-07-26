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
		),
		.library(
			name: "KovaleePurchases",
			targets: [
				"KovaleePurchases",
			]
		),
		.library(
			name: "KovaleeRemoteConfig",
			targets: [
				"KovaleeRemoteConfig",
			]
		),
		.library(
			name: "KovaleeAds",
			targets: [
				"KovaleeAds",
			]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/adjust/ios_sdk", from: Version(4, 33, 5)),
		.package(url: "https://github.com/amplitude/Amplitude-Swift", from: Version(0, 4, 6)),
		.package(url: "https://github.com/RevenueCat/purchases-ios", from: Version(4, 25, 0)),
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: Version(10, 12, 0)),
		.package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", from: Version(11, 10, 1))
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
		),
		.target(
			name: "KovaleePurchases",
			dependencies: [
				"KovaleeSDK",
				.product(name: "RevenueCat", package: "purchases-ios")
			]
		),
		.target(
			name: "KovaleeRemoteConfig",
			dependencies: [
				"KovaleeSDK",
				.product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
				.product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk")
			]
		),
		.target(
			name: "KovaleeAds",
			dependencies: [
				"KovaleeSDK",
				"AdColony",
				"AppLovinMediationAdColonyAdapter",
				"AppLovinMediationFacebookAdapter",
				"AppLovinMediationIronSourceAdapter",
				"AppLovinMediationUnityAdsAdapter",
				"FBAudienceNetwork",
				"IronSource",
				"UnityAds",
				.product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package")
			]
		),

		.binaryTarget(
			name: "AdColony",
			path: "./Frameworks/AdColony.xcframework"
		),
		.binaryTarget(
			name: "AppLovinMediationAdColonyAdapter",
			path: "./Frameworks/AppLovinMediationAdColonyAdapter.xcframework"
		),
		.binaryTarget(
			name: "AppLovinMediationFacebookAdapter",
			path: "./Frameworks/AppLovinMediationFacebookAdapter.xcframework"
		),
		.binaryTarget(
			name: "AppLovinMediationIronSourceAdapter",
			path: "./Frameworks/AppLovinMediationIronSourceAdapter.xcframework"
		),
		.binaryTarget(
			name: "AppLovinMediationUnityAdsAdapter",
			path: "./Frameworks/AppLovinMediationUnityAdsAdapter.xcframework"
		),
		.binaryTarget(
			name: "FBAudienceNetwork",
			path: "./Frameworks/FBAudienceNetwork.xcframework"
		),
		.binaryTarget(
			name: "IronSource",
			path: "./Frameworks/IronSource.xcframework"
		),
		.binaryTarget(
			name: "UnityAds",
			path: "./Frameworks/UnityAds.xcframework"
		),
    ]
)
