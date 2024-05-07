//
//  APIService.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import Foundation

// MARK: - APIService 정의
// API 호출 동작을 수행하는 객체

struct APIService {
    
    static func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        resultSortType: ResultOrderType = .recommendPath,
        searchType: SearchType = .inCity,
        searchPathType: SearchPathType = .all,
        completion: @escaping (Result<Data, APIServiceError>) -> Void) {
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
                completion(.failure(APIServiceError.invalidURL))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    completion(.failure(APIServiceError.requestFail))
                }
                guard let data = data else {
                    completion(.failure(APIServiceError.noData))
                    return
                }
                completion(.success(data))
            }.resume()
    }
}
