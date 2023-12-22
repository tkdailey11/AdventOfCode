// swift-tools-version:5.9

import Foundation
import PackageDescription

// MARK: - shared

var package = Package(
	name: "AdventOfCode",
	platforms: [
        .macOS(.v14),
	],
	products: [
		.library(name: "Tools", targets: ["Tools"]),
		.executable(name: "VisualizerTestApp", targets: ["VisualizerTestApp"]),
		.executable(name: "Solutions2023", targets: ["Solutions2023"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/rbruinier/SwiftMicroPNG", branch: "main"),
		.package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
        .package(url: "https://github.com/davecom/SwiftGraph", .upToNextMajor(from: "3.1.0")),
	],
	targets: [
		.target(
			name: "Tools",
			dependencies: [
				.product(name: "Collections", package: "swift-collections"),
				.product(name: "MicroPNG", package: "SwiftMicroPNG"),
			],
			resources: [
				.copy("Visualization/Resources"),
			]

		),
		.executableTarget(
			name: "VisualizerTestApp",
			dependencies: [
				"Tools"
			]
		),
		.testTarget(
			name: "ToolsTests",
			dependencies: [
				"Tools",
			]
		),
		.executableTarget(
			name: "Solutions2023",
			dependencies: [
				"Tools",
                .product(name: "SwiftGraph", package: "SwiftGraph")
			],
			path: "Sources/Solutions/2023",
			resources: [
				.copy("Input"),
			]
		),
	]
)
