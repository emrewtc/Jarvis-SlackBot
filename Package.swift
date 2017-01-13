import PackageDescription

let package = Package(
    name: "JarvisBot",
    dependencies:
    [
        .Package(url:"https://github.com/pvzig/SlackKit.git", majorVersion: 3)
    ]
)
