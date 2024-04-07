import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "StationSearchFeature",
    dependencies: [
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
