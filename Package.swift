// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcodebuild-to-md",
    platforms: [
        .macOS(.v10_15)
    ],

    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/davidahouse/XCResultKit",
        from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "xcodebuild-to-md",
            dependencies: ["XCResultKit"]),
        .testTarget(
            name: "xcodebuild-to-mdTests",
            dependencies: ["xcodebuild-to-md"]),
    ],

    swiftLanguageVersions: [.v5]
)
