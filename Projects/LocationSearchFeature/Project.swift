import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "LocationSearchFeature",
    dependencies: [
        Module.domain.project,
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
