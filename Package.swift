// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BookReadingManager",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "BookReadingManagerCore",
            path: "Sources/BookReadingManagerCore"
        ),
        .executableTarget(
            name: "BookReadingManager",
            dependencies: ["BookReadingManagerCore"],
            path: "Sources/BookReadingManager"
        ),
        .testTarget(
            name: "BookReadingManagerTests",
            dependencies: ["BookReadingManagerCore"],
            path: "Tests/BookReadingManagerTests"
        )
    ]
)
