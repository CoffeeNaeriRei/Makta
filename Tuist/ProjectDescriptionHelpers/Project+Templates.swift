import ProjectDescription

extension Project {
    
    static let bundleID = "com.coffeenaerirei"
    static let iOSVeresion = "16.0"
    
    // .app으로 프로젝트를 생성하는 코드
    public static func app(
        name: String,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil
    ) -> Project {
        return createProject(
            name: name,
            product: .app,
            bundleID: bundleID + ".\(name)",
            packages: packages,
            dependencies: dependencies,
            resources: resources
        )
    }
    
    // .staticFramework로 프로젝트를 생성하는 메서드
    public static func framework(
        name: String,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil
    ) -> Project {
        return createProject(
            name: name,
            product: .staticFramework,
            bundleID: bundleID + ".\(name)",
            packages: packages,
            dependencies: dependencies,
            resources: resources
        )
    }
}

extension Project {
    
    // 프로젝트 생성 메서드
    public static func createProject(
        name: String,
        product: Product,
        bundleID: String,
        schemes: [Scheme] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil
    ) -> Project {
                
        let settings = Settings.settings(
            base: [
                "OTHER_LDFLAGS": "-ObjC",
//                "OTHER_SWIFT_FLAGS": "$(inherited) -Xcc -Wno-error=non-modular-include-in-framework-module",
                "HEADER_SEARCH_PATHS": [
                    "$(inherited)",
                    "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/FlexLayout/Sources/yoga/include/yoga",
                    "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/FlexLayout/Sources/YogaKit/include/YogaKit"
                ]
            ]
        )
        
        return Project(
            name: name,
            packages: packages,
            targets: [
                Target(
                    name: name,
                    destinations: .iOS,
                    product: product,
                    bundleId: bundleID,
                    deploymentTargets: .iOS(iOSVeresion),
                    infoPlist: .file(path: .relativeToRoot("Support/Info.plist")),
                    sources: ["Sources/**"],
                    resources: resources,
                    scripts: [.SwiftLintScriptString],
                    dependencies: dependencies,
                    settings: settings
                ),
                Target( // 테스트 타겟
                    name: "\(name)Tests",
                    destinations: .iOS,
                    product: .unitTests,
                    bundleId: bundleID,
                    deploymentTargets: .iOS(iOSVeresion),
                    infoPlist: .file(path: .relativeToRoot("Support/Info.plist")),
                    sources: ["Tests/**"],
                    scripts: [.SwiftLintScriptString],
                    dependencies: [
                        .target(name: name)
                    ],
                    settings: settings
                )
            ],
            schemes: schemes
        )
    }
}


