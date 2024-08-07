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
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-Swift", .upToNextMajor(from: "1.4.3")),
        .package(url: "https://github.com/Survicate/survicate-ios-sdk", .upToNextMajor(from: "5.0.0")),
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
                .product(name: "AmplitudeSwift", package: "Amplitude-Swift"),
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
                .product(
                    name: "Survicate",
                    package: "survicate-ios-sdk",
                    condition: .when(platforms: [.iOS])
                ),
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
}

extension String {
    static let framework = "KovaleeFramework"
    static let sdk = "KovaleeSDK"
    static let sdkUI = "KovaleeSDKUI"
    static let survey = "KovaleeSurvey"
}
