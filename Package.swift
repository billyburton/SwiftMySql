import PackageDescription

let package = Package(
    name: "SwiftMySql",
    dependencies: [
        .Package(url: "https://github.com/billyburton/SwiftCMySql.git", majorVersion: 0)
    ]
)
