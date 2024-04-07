//
//  TargetScriptExtension.swift
//  MakchaManifests
//
//  Created by 김영빈 on 4/8/24.
//

import Foundation
import ProjectDescription

public extension TargetScript {
    
    // SwiftLint 스크립트
    static let SwiftLintScriptString = TargetScript.pre(
        // 프로젝트에 넣은 SwiftLint exec 실행파일
        script: """
        ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
        
        ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
        
        """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
}
