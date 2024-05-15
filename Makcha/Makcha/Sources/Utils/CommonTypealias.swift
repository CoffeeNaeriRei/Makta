//
//  CommonTypealias.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - 공통적으로 사용되는 typealias

typealias XYCoordinate = (lonX: String, latY: String)
typealias RealtimeArrivalTuple = (first: Int?, second: Int?) // 실시간 도착 정보 튜플 (첫번째도착남은시간, 두번째도착남은시간)

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
