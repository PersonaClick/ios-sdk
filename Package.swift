// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PersonaClick",
    platforms: [
            .iOS(.v11),
            .macOS(.v11)
        ],
        products: [
            // PersonaClick SDK and libraries produced by a package.
            .library(name: "PersonaClick",
            targets: ["PersonaClick"]),
        ],
        dependencies: [
             // .package(url: /* personaclick.com */, now: pod "3.5.6"),
        ],
        targets: [
            .target(
                name: "PersonaClick",
                path: "PersonaClick/Classes",
                resources: [
                    .process("Resources")
                ],
                linkerSettings: [
                    .linkedFramework("Foundation"),
                    .linkedFramework("UIKit", .when(platforms: [.iOS])),
                    .linkedFramework("AppKit", .when(platforms: [.macOS])),
                ]
        )
    ]
)

