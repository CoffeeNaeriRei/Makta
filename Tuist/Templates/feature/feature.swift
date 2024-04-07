//
//  feature.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영빈 on 4/3/24.
//

// MARK: - Feature 모듈 생성 템플릿
/*
 scaffold 사용 커맨드
 👉 `tuist scaffold feature --name 피처모듈이름`
 */

import ProjectDescription

let nameAttribute = Template.Attribute.required("name")

let template = Template(
    description: "Feature 모듈을 생성하기 위한 템플릿",
    attributes: [
        nameAttribute
    ],
    items: [
        // Sources, Tests 폴더 생성
        .string(
            path: "Projects/\(nameAttribute)Feature/Sources/Source.swift",
            contents: "// \(nameAttribute)Feature 모듈의 Sources에 생성됨"
        ),
        .string(
            path: "Projects/\(nameAttribute)Feature/Tests/Tests.swift",
            contents: "// \(nameAttribute)Feature 모듈의 Tests에 생성됨"
        ),
        // Project.swift 파일 생성
        .file(
            path: "Projects/\(nameAttribute)Feature/Project.swift",
            templatePath: "project.stencil"
        )
    ]
)
