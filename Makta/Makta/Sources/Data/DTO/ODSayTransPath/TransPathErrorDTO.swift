//
//  TransPathErrorDTO.swift
//  Makta
//
//  Created by 김영빈 on 9/16/24.
//

enum TransPathError: Error {
    case serverError
    case inputError
    case noEndPoint
    case noServiceArea
    case closeEndpoint
    case noResult
}

// MARK: - ODSay 대중교통 환승경로 API의 에러 응답 DTO
/// https://lab.odsay.com/guide/guide#guideWeb_2

struct TransPathErrorDTO: TransPathDTOResponsable, Codable {
    var type: ResponseType? = .error
    
    let error: TransPathErrorBody
    
    /**
     에러 코드
     - `500` : 서버 내부 오류
     - `-8` : 필수 입력값 형식 및 범위 오류
     - `-9` : 필수 입력값 누락
     - `3` : 출발지 정류장이 없습니다.
     - `4` : 도착지 정류장이 없습니다.
     - `5` : 출,도착지 정류장이 없습니다.
     - `6` : 서비스 지역이 아닙니다.
     - `-98` : 출, 도착지가 700m이내입니다.
     - `-99` : 검색결과가 없습니다.
     */
    struct TransPathErrorBody: Codable {
        let msg: String
        let code: String
        
        var errorType: TransPathError {
            switch code {
            case "-8", "-9": .inputError
            case "3", "4", "5": .noEndPoint
            case "6": .noServiceArea
            case "-98": .closeEndpoint
            case "-99": .noResult
            default: .serverError
            }
        }
    }
}
