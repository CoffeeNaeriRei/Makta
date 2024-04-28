import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "HomeFeature",
    dependencies: [
        Module.domain.project,
        Module.designSystem.project,
        Module.utils.project,
        Module.thirdPartyLib.project
    ]
)
