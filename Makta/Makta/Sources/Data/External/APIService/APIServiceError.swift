//
//  APIServiceError.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - API 호출 시 발생하는 에러 정의

enum APIServiceError: Error {
    case invalidURL
    case requestFail
    case noData
    case decodingError
    case entityConvertError
}
