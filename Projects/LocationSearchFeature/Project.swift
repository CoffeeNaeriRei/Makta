import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "LocationSearchFeature",
    dependencies: [
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
