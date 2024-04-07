//
//  TargetDependencyExtension.swift
//  Config
//
//  Created by 김영빈 on 4/3/24.
//

import ProjectDescription

public extension Package {
    static let rxSwift: Package = .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.5.0"))
    static let flexLayout: Package = .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    static let pinLayout: Package = .remote(url: "https://github.com/layoutBox/PinLayout", requirement: .upToNextMajor(from: "1.10.5"))
}

public extension TargetDependency {
    static let rxSwift: TargetDependency = .external(name: "RxSwift")
    static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let rxRelay: TargetDependency = .external(name: "RxRelay")
    static let flexLayout: TargetDependency = .external(name: "FlexLayout")
    static let pinLayout: TargetDependency = .external(name: "PinLayout")
}
