//
//  Dependencies.swift
//  Config
//
//  Created by 김영빈 on 4/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            Package.rxSwift,
            Package.flexLayout,
            Package.pinLayout
        ],
//        // SPM에서는 의존성 주입 시 static이 기본 👉 각각 다른 모듈에서 해당 라이브러리를 import하면 코드가 복사되기 때문에 dynamic으로
//        productTypes: [
//            "RxSwift": .framework,
//            "RxCocoa": .framework,
//            "RxRelay": .framework,
//            "FlexLayout": .framework,
//            "FlexLayoutYogaKit": .framework,
//            "FlexLayoutYoga": .framework,
//            "PinLayout": .framework
//        ],
        targetSettings: [
            "FlexLayoutYogaKit": [
                "DEFINES_MODULE": "NO"
            ],
            "FlexLayoutYoga": [
                "DEFINES_MODULE": "NO"
            ]
        ]
    ),
    platforms: [.iOS]
)
