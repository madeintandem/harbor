// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Harbor",
  products: [
    .executable(
      name: "Harbor-CLI",
      targets: ["CLI"]),
    .library(
      name: "Harbor",
      targets: ["Harbor"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      from: "4.6.0"),
    .package(
      url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
      from: "4.0.0"),
    .package(
      url: "https://github.com/Thomvis/BrightFutures.git",
      from: "6.0.1"),
    .package(
      url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
      from: "3.1.0"),
    .package(
      url: "https://github.com/kylef/Commander",
      from: "0.8.0"),
    .package(
      url: "https://github.com/Quick/Quick.git",
      from: "1.2.0"),
    .package(
      url: "https://github.com/Quick/Nimble.git",
      from: "7.0.3"),
  ],
  targets: [
    .target(
      name: "CLI",
      dependencies: [
        "Harbor",
        "Commander",
      ]),
    .target(
      name: "Harbor",
      dependencies: [
        "Alamofire",
        "SwiftyJSON",
        "BrightFutures",
        "KeychainAccess"
      ]),
    .testTarget(
      name: "HarborTests",
      dependencies: [
        "Harbor",
        "Quick",
        "Nimble",
      ]),
  ]
)
