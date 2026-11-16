// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PersonaClick",
    platforms: [
            .iOS(.v15)
        ],
        products: [
            // PersonaClick SDK and libraries produced by a package.
            .library(name: "PersonaClick",
            targets: ["PersonaClick"]),
        ],
        dependencies: [],
        targets: [
            .target(
                name: "PersonaClick",
                path: "PersonaClick/Classes",
                exclude: ["Resources/Assets.swift"],
                resources: [
                    .process("Resources")
                ],
                linkerSettings: [
                    .linkedFramework("Foundation"),
                    .linkedFramework("UIKit"),
                ]
        ),
            // Core tests without the demo app or CocoaPods; UIKit, so they run on an iOS simulator.
            .testTarget(
                name: "PersonaClickCoreTests",
                dependencies: ["PersonaClick"],
                path: "Tests/PersonaClickCoreTests",
                resources: [
                    .copy("Fixtures")
                ]
            )
    ]
)
