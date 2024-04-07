//
//  noResources.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영빈 on 4/3/24.
//

// MARK: - Resources 디렉토리를 포함하지 않는 모듈 생성 템플릿
/*
 scaffold 사용 커맨드
 👉 `tuist scaffold noResources --name 모듈이름`
 */

import ProjectDescription

let nameAttribute = Template.Attribute.required("name")

let template = Template(
    description: "Resources 디렉토리를 포함하지 않는 모듈을 생성하기 위한 템플릿",
    attributes: [
        nameAttribute
    ],
    items: [
        // Sources, Tests 폴더 생성
        .string(
            path: "Projects/\(nameAttribute)/Sources/Source.swift",
            contents: "// \(nameAttribute) 모듈의 Sources에 생성됨"
        ),
        .string(
            path: "Projects/\(nameAttribute)/Tests/Tests.swift",
            contents: "// \(nameAttribute) 모듈의 Tests에 생성됨"
        ),
        // Project.swift 파일 생성
        .file(
            path: "Projects/\(nameAttribute)/Project.swift",
            templatePath: "project.stencil"
        )
    ]
)
