//
//  APIService.swift
//  Data
//
//  Created by 김영빈 on 5/3/24.
//

import Foundation

// API 호출 시 발생하는 에러
enum APIRequestError: Error {
    case invalidURL
    case requestFail
    case noData
}

final class APIService {
    
    // 경로검색결과 정렬방식
    enum ResultOrderType: Int {
        case recommendPath = 0 // 추천경로순
        case transType = 1 // 타입별 정렬 (지하철, 버스, 버스+지하철, 지하철+버스, 버스+지하철+버스)
    }
    // 도시내/도시간 이동 선택
    enum SearchType: Int {
        case inCity = 0 // 도시내
        case cityToCity = 1 // 도시간
    }
    // 도시 내 경로수단 지정
    enum SearchPathType: Int {
        case all = 0 // 모두
        case subway = 1 // 지하철
        case bus = 2 // 버스
    }
    
    typealias XYCoordinate = (lonX: String, latY: String)
    
    static func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        resultSortType: ResultOrderType = .recommendPath,
        searchType: SearchType = .inCity,
        searchPathType: SearchPathType = .all,
        completion: @escaping (Result<Data, APIRequestError>) -> Void) {
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ODSAY_API_KEY") as? String else { return }
            var transPathURL = "https://api.odsay.com/v1/api/searchPubTransPathT?"
            transPathURL += "apiKey=\(apiKey)"
            transPathURL += "&output=json"
            transPathURL += "&SX=\(start.lonX)&SY=\(start.latY)"
            transPathURL += "&EX=\(end.lonX)&EY=\(end.latY)"
            transPathURL += "&OPT=\(resultSortType.rawValue)"
            transPathURL += "&SearchType=\(searchType.rawValue)"
            transPathURL += "&SearchPathType=\(searchPathType.rawValue)"
            guard let url = URL(string: transPathURL) else {
                completion(.failure(APIRequestError.invalidURL))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    completion(.failure(APIRequestError.requestFail))
                }
                guard let data = data else {
                    completion(.failure(APIRequestError.noData))
                    return
                }
                completion(.success(data))
            }.resume()
    }
}
