import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "SubwayCheckFeature",
    dependencies: [
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
