import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "DetailPathFeature",
    dependencies: [
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
