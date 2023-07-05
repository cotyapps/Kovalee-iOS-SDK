// swift-tools-version: 5.7.1
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
    ],
    dependencies: [
		.package(url: "https://github.com/adjust/ios_sdk", exact: "4.33.4"),
		.package(url: "https://github.com/amplitude/Amplitude-Swift", exact: "0.4.6"),
		.package(url: "https://github.com/RevenueCat/purchases-ios", exact: "4.18.0"),
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.11.0"),
		.package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", .upToNextMajor(from: "11.10.1"))
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
				"AdColony",
				"AppLovinMediationAdColonyAdapter",
				"AppLovinMediationFacebookAdapter",
				"AppLovinMediationIronSourceAdapter",
				"AppLovinMediationUnityAdsAdapter",
//				"AppLovinSDK",
				"FBAudienceNetwork",
				"IronSource",
				"UnityAds",
				.product(name: "Adjust", package: "ios_sdk"),
				.product(name: "Amplitude-Swift", package: "Amplitude-swift"),
				.product(name: "RevenueCat", package: "purchases-ios"),
				.product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
				.product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk"),
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
//		.binaryTarget(
//			name: "AppLovinSDK",
//			path: "./Frameworks/AppLovinSDK.xcframework"
//		),
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
