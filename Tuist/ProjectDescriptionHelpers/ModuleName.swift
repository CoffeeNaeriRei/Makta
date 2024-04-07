//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영빈 on 4/3/24.
//

import ProjectDescription

public enum Module {
    case app
    case homeFeature
    case stationSearchFeature
    case subwayCheckFeature
//    case domain
    case data
    case designSystem
    case utils
    case thirdPartyLib
}

extension Module {
    public var name: String {
        switch self {
        case .app:
            return "App"
        case .homeFeature:
            return "HomeFeature"
        case .stationSearchFeature:
            return "StationSearchFeature"
        case .subwayCheckFeature:
            return "SubwayCheckFeature"
//        case .domain:
//            return "Domain"
        case .data:
            return "Data"
        case .designSystem:
            return "DesignSystem"
        case .utils:
            return "Utils"
        case .thirdPartyLib:
            return "ThirdPartyLib"
        }
    }
    
    public var path: ProjectDescription.Path {
        return .relativeToRoot("Projects/" + name)
    }
    
    public var project: TargetDependency {
        return .project(target: name, path: path)
    }
}

extension Module: CaseIterable { }
