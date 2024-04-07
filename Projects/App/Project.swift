//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영빈 on 4/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "App",
    dependencies: [
//        Module.domain
        Module.homeFeature,
        Module.stationSearchFeature,
        Module.subwayCheckFeature,
        Module.data,
    ].map { $0.project },
    resources: .default
)
