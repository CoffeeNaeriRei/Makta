import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "ThirdPartyLib",
    dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
        .flexLayout,
        .pinLayout
    ]
)
