// swift-tools-version:6.1
import Foundation
import PackageDescription

let packageDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()

let yearNames = ((try? FileManager.default.contentsOfDirectory(atPath: packageDirectory.path)) ?? [])
    .filter { $0.range(of: #"^AOC\d{4}$"#, options: .regularExpression) != nil }
    .sorted()

let yearTargets: [Target] = yearNames.map { year in
    .target(
        name: year,
        dependencies: ["AOCTools"],
        path: year,
        resources: [.copy("Input")]
    )
}

let toolsTarget: Target = .target(
    name: "AOCTools",
    dependencies: [
        .product(name: "Collections", package: "swift-collections"),
        .product(name: "SwiftGraph", package: "SwiftGraph"),
    ],
    path: "AOCTools"
)

let executableDependencies: [Target.Dependency] = (["AOCTools"] + yearNames).map { .target(name: $0) }

let executableTarget: Target = .executableTarget(
    name: "AdventOfCode",
    dependencies: executableDependencies,
    path: "AdventOfCode"
)

let allTargets: [Target] = [toolsTarget] + yearTargets + [executableTarget]

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .executable(name: "AdventOfCode", targets: ["AdventOfCode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.2.1"),
        .package(url: "https://github.com/davecom/SwiftGraph", exact: "3.1.0"),
    ],
    targets: allTargets,
    swiftLanguageModes: [.v5]
)
