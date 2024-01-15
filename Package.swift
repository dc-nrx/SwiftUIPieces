// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIPieces",
    platforms: [.iOS("16.4")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUIPieces",
            targets: ["SwiftUIPieces"]),
    ],
	dependencies: [
//		.package(url: "https://github.com/dc-nrx/SwiftUIDebugger.git", branch: "main"),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIPieces"
//			,dependencies: ["SwiftUIDebugger"]
		),
        .testTarget(
            name: "SwiftUIPiecesTests",
            dependencies: ["SwiftUIPieces"]
		),
    ]
)
