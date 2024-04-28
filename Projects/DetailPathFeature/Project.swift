import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "DetailPathFeature",
    dependencies: [
        Module.domain.project,
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
