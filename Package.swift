// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PersonaClick",
    platforms: [
            .iOS(.v11),
            .macOS(.v10_15)
        ],
        products: [
            // Products define the executables and libraries produced by a package, and make them visible to other packages.
            .library(name: "PersonaClick",
            targets: ["PersonaClick"]),
        ],
        dependencies: [
             // Dependencies declare other packages that this package depends on.
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

