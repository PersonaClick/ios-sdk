// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PersonaClick",
    platforms: [
            .iOS(.v12)
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
        )
    ]
)
