// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "Masaike",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Masaike",
            path: "Sources/Masaike",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
