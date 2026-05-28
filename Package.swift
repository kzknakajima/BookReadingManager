// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BookReadingManager",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "BookReadingManager",
            path: "Sources/BookReadingManager"
        )
    ]
)
