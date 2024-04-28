import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Domain",
    dependencies: [
        Module.thirdPartyLib.project
    ]
)
