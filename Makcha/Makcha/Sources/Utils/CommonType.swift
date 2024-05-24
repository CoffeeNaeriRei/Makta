//
//  CommonType.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - 공통적으로 사용되는 타입

typealias XYCoordinate = (lonX: String, latY: String)

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
