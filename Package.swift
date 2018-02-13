// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Harbor",
  products: [
    .library(
      name: "Harbor",
      targets: ["Harbor"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      from: "4.6.0"),
    .package(
      url: "https://github.com/antitypical/Result.git",
      from: "3.2.4"),
    .package(
      url: "https://github.com/Quick/Quick.git",
      from: "1.2.0"),
    .package(
      url: "https://github.com/Quick/Nimble.git",
      from: "7.0.3"),
  ],
  targets: [
    .target(
      name: "Harbor",
      dependencies: [
        "Alamofire",
        "Result"
      ]),
    .testTarget(
      name: "HarborTests",
      dependencies: [
        "Harbor",
        "Quick",
        "Nimble"
      ]),
  ]
)
