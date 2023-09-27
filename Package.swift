// swift-tools-version:5.9
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "papyrus",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15"),
    ],
    products: [
        .executable(name: "Example", targets: ["Example"]),
        .library(name: "Papyrus", targets: ["Papyrus"]),
        .library(name: "PapyrusCore", targets: ["PapyrusCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: ["Papyrus"],
            path: "Example"
        ),
        .target(
            name: "Papyrus",
            dependencies: [
                .byName(name: "PapyrusCore"),
                .product(name: "Alamofire", package: "Alamofire"),
            ],
            path: "Papyrus"
        ),
        .target(
            name: "PapyrusCore",
            dependencies: [
                .byName(name: "PapyrusPlugin"),
            ],
            path: "PapyrusCore/Sources"
        ),
        .macro(
            name: "PapyrusPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "PapyrusPlugin/Sources"
        ),
        .testTarget(
            name: "PapyrusCoreTests",
            dependencies: ["PapyrusCore"],
            path: "PapyrusCore/Tests"
        ),
        .testTarget(
            name: "PapyrusPluginTests",
            dependencies: ["PapyrusPlugin", .product(name: "MacroTesting", package: "swift-macro-testing")],
            path: "PapyrusPlugin/Tests"
        ),
    ]
)
