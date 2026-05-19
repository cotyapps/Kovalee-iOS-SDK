// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KovaleeSDK",
    defaultLocalization: "en",
    platforms: [.macOS(.v12), .iOS(.v15), .watchOS(.v8), .tvOS(.v15), .macCatalyst(.v15), .visionOS(.v1)],
    products: [
        .library(
            name: .sdk,
            targets: [.sdk]
        ),
        .library(
            name: .sdkUI,
            targets: [.sdkUI]
        ),
        .library(
            name: .survey,
            targets: [.survey]
        ),
        .library(
            name: .kovaleePurchases,
            targets: [
                .kovaleePurchases,
            ]
        ),
        .library(
            name: .kovaleeAttribution,
            targets: [
                .kovaleeAttribution,
            ]
        ),
        .library(
            name: .kovaleeRemoteConfig,
            targets: [
                .kovaleeRemoteConfig,
            ]
        ),
        .library(
            name: .kovaleeTikTok,
            targets: [
                .kovaleeTikTok,
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-Swift", .upToNextMajor(from: "1.4.3")),
        .package(url: "https://github.com/amplitude/AmplitudeSessionReplay-iOS", .upToNextMajor(from: "0.9.5")),
        .package(url: "https://github.com/Survicate/survicate-ios-sdk", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.6.0")),
        .package(url: "https://github.com/RevenueCat/purchases-ios-spm.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/adjust/ios_sdk", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/tiktok/tiktok-business-ios-sdk", .upToNextMajor(from: "1.6.0")),
    ],
    targets: [
        .binaryTarget(
            name: .framework,
            path: "./Frameworks/KovaleeFramework.xcframework.zip"
        ),

        .target(
            name: .sdk,
            dependencies: [
                .framework,
                .amplitude,
                .amplitudeSessionReplay,
                .firebaseAnalytics,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: .sdkUI,
            dependencies: [
                .sdk,
                .kovaleePurchases,
            ]
        ),
        .target(
            name: .survey,
            dependencies: [
                .sdk,
                .survicate,
            ]
        ),
        .target(
            name: .kovaleeRemoteConfig,
            dependencies: [
                .sdk,
                .framework,
                .firebaseRemoteConfig,
                .firebaseAnalytics,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: .kovaleePurchases,
            dependencies: [
                .sdk,
                .revenueCat,
                .kovaleeRemoteConfig,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: .kovaleeAttribution,
            dependencies: [
                .sdk,
                .AdjustSdk,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: .kovaleeTikTok,
            dependencies: [
                .sdk,
                .tikTokBusinessSDK,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)

extension Target.Dependency {
    static var framework: Self {
        .target(name: .framework)
    }

    static var sdk: Self {
        .target(name: .sdk)
    }

    static var ui: Self {
        .target(name: .sdkUI, condition: .when(platforms: [.iOS]))
    }

    static var survey: Self {
        .target(name: .survey)
    }

    static var kovaleeRemoteConfig: Self {
        .target(name: .kovaleeRemoteConfig)
    }

    static var kovaleePurchases: Self {
        .target(name: .kovaleePurchases)
    }

    static var kovaleeAttribution: Self {
        .target(name: .kovaleeAttribution)
    }

    static var kovaleeTikTok: Self {
        .target(name: .kovaleeTikTok)
    }
}

extension Target.Dependency {
    static var survicate: Self {
        .product(
            name: "Survicate",
            package: "survicate-ios-sdk",
            condition: .when(platforms: [.iOS])
        )
    }

    static var amplitudeSessionReplay: Self {
        .product(
            name: "AmplitudeSwiftSessionReplayPlugin",
            package: "AmplitudeSessionReplay-iOS",
            condition: .when(platforms: [.iOS])
        )
    }

    static var amplitude: Self {
        .product(
            name: "AmplitudeSwift",
            package: "Amplitude-Swift",
            condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])
        )
    }

    static var revenueCat: Self {
        .product(
            name: "RevenueCat",
            package: "purchases-ios-spm",
            condition: .when(platforms: [.macOS, .watchOS, .tvOS, .iOS, .visionOS])
        )
    }

    static var AdjustSdk: Self {
        .product(
            name: "AdjustSdk",
            package: "ios_sdk",
            condition: .when(platforms: [.iOS, .tvOS])
        )
    }

    static var firebaseRemoteConfig: Self {
        .product(
            name: "FirebaseRemoteConfig",
            package: "firebase-ios-sdk",
            condition: .when(platforms: [.iOS, .macCatalyst, .macOS, .tvOS, .watchOS])
        )
    }

    static var firebaseAnalytics: Self {
        .product(
            name: "FirebaseAnalytics",
            package: "firebase-ios-sdk",
            condition: .when(platforms: [.iOS, .macCatalyst, .macOS, .tvOS, .watchOS])
        )
    }

    static var tikTokBusinessSDK: Self {
        .product(
            name: "TikTokBusinessSDK",
            package: "tiktok-business-ios-sdk",
            condition: .when(platforms: [.iOS])
        )
    }
}

extension String {
    static let framework = "KovaleeFramework"
    static let sdk = "KovaleeSDK"
    static let sdkUI = "KovaleeSDKUI"
    static let survey = "KovaleeSurvey"
    static let kovaleeRemoteConfig = "KovaleeRemoteConfig"
    static let kovaleePurchases = "KovaleePurchases"
    static let kovaleeAttribution = "KovaleeAttribution"
    static let kovaleeTikTok = "KovaleeTikTok"
}
