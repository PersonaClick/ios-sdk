// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PersonaClick",
    platforms: [
            .iOS(.v11),
            .macOS(.v10_15)
        ],
        products: [
            // PersonaClick SDK and libraries produced by a package.
            .library(name: "PersonaClick",
            targets: ["PersonaClick"]),
        ],
        dependencies: [
             // Dependencies declare other packages that PersonaClick depends on.
             // .package(url: /* package url */, from: "1.0.0"),
        ],
        targets: [
            .target(
                name: "PersonaClick",
                path: "PersonaClick/Classes/"
                // resources: [.process("Resources/*.der")],
                // publicHeadersPath: "."
        )
    ]
)

