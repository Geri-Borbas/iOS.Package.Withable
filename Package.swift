// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Withable",
    products: [
        .library(
            name: "Withable",
            targets: ["Withable"]
        )
    ],
    targets: [
        .target(
            name: "Withable",
            path: "Withable"
        )
    ]
)
