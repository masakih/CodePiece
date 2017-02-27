import PackageDescription

let package = Package(
    name: "CodePieceModule",
    dependencies: [
        .Package(url: "https://github.com/es-kumagai/Swim", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/es-kumagai/Ocean", majorVersion: 0, minor: 1)
    ]
)
