import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Data",
    dependencies: [
        Module.domain.project
    ],
    resources: .default
)
