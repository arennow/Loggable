// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Loggable",
					  platforms: [
					  	.iOS(.v18),
					  	.macOS(.v15),
					  ],
					  products: [
					  	.library(name: "Loggable",
								   targets: ["Loggable"]),
					  ],
					  dependencies: [
					  	.package(url: "https://github.com/arennow/DateTestHelpers.git",
								   .upToNextMajor(from: "0.1.1")),
					  	.package(url: "https://github.com/apple/swift-log.git",
								   .upToNextMajor(from: "1.6.3")),
					  ],
					  targets: [
					  	.target(name: "Loggable",
								  dependencies: [
								  	.product(name: "Logging", package: "swift-log"),
								  ],
								  swiftSettings: [
								  	.enableExperimentalFeature("MemberImportVisibility"),
								  ]),
					  	.testTarget(name: "LoggableTests",
									  dependencies: [
									  	"Loggable",
									  	"DateTestHelpers",
									  ],
									  swiftSettings: [
									  	.enableExperimentalFeature("MemberImportVisibility"),
									  ]),
					  ])
