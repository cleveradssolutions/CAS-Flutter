// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clever_ads_solutions",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "clever-ads-solutions", targets: ["clever_ads_solutions"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/cleveradssolutions/CAS-iOS.git",
            .upToNextMinor(from: "4.8.3-beta1")
        ),
    ],
    targets: [
        .target(
            name: "clever_ads_solutions",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "CleverAdsSolutionsSPM", package: "CAS-iOS"),
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
