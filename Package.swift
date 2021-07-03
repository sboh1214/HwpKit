// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Hwp-Swift",
    products: [
        .library(name: "CoreHwp", targets: ["CoreHwp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/OLEKit.git", .exact("0.3.1")),
        .package(url: "https://github.com/tsolomko/SWCompression.git", .exact("4.5.11")),

        .package(url: "https://github.com/Quick/Nimble", .exact("9.2.0")),
    ],
    targets: [
        .target(
            name: "CoreHwp",
            dependencies: [
                "OLEKit",
                "SWCompression",
            ]
        ),
        .testTarget(
            name: "CoreHwpTests",
            dependencies: [
                "CoreHwp",
                "Nimble",
            ]
        ),
    ]
)
