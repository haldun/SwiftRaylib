// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let packageDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let raylibStaticLib = "\(packageDir)/raylib-6.0_macos/lib/libraylib.a"

let package = Package(
    name: "SwiftRaylib",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .systemLibrary(name: "raylib", path: "raylib-6.0_macos"),
        .executableTarget(
            name: "SwiftRaylib",
            dependencies: ["raylib"],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", raylibStaticLib]),
                .linkedFramework("Cocoa"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("CoreAudio"),
                .linkedFramework("IOKit"),
                .linkedFramework("OpenGL"),
            ]
        ),
        .testTarget(
            name: "SwiftRaylibTests",
            dependencies: ["SwiftRaylib"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
