// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "AStack",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "AStack",
      targets: ["AStack"])
  ],
  targets: [
    .target(
      name: "AStack",
      dependencies: [])
  ]
)
