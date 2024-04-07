//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영빈 on 4/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Makcha",
    projects: [
        Module.app,
        Module.homeFeature,
        Module.stationSearchFeature,
        Module.subwayCheckFeature,
        Module.data
    ].map { $0.path }
)
