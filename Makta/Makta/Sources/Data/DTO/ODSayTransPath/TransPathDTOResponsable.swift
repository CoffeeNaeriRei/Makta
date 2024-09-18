//
//  TransPathDTOResponsable.swift
//  Makta
//
//  Created by 김영빈 on 9/16/24.
//

// MARK: - ODSay API 대중교통 환승경로 응답 데이터 형식을 추상화한 프로토콜
/// 응답 코드 200 의 경우에도 다른 형식의 성공 / 실패 응답이 존재하기 때문에, 이를 구분하기 위해 필요

protocol TransPathDTOResponsable {
    var type: ResponseType? { get set }
}

enum ResponseType: Codable {
    case success
    case error
}
