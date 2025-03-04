// swift-tools-version: 5.5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KovaleeSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: .sdk,
            targets: [
                .sdk, .sdkUI, .survey,
            ]
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
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-Swift", .upToNextMajor(from: "1.4.3")),
        .package(url: "https://github.com/Survicate/survicate-ios-sdk", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.0.0")),
        .package(url: "https://github.com/RevenueCat/purchases-ios", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/adjust/ios_sdk", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .binaryTarget(
            name: .framework,
            path: "./Frameworks/KovaleeFramework.xcframework"
        ),

        .target(
            name: .sdk,
            dependencies: [
                .framework,
                .amplitude,
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: .sdkUI,
            dependencies: [
                .sdk,
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
        .target(name: .sdkUI)
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
}

extension Target.Dependency {
    static var survicate: Self {
        .product(
            name: "Survicate",
            package: "survicate-ios-sdk",
            condition: .when(platforms: [.iOS])
        )
    }

    static var amplitude: Self {
        .product(name: "AmplitudeSwift", package: "Amplitude-Swift")
    }

    static var revenueCat: Self {
        .product(name: "RevenueCat", package: "purchases-ios")
    }

    static var AdjustSdk: Self {
        .product(name: "AdjustSdk", package: "ios_sdk")
    }

    static var firebaseRemoteConfig: Self {
        .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
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
}
