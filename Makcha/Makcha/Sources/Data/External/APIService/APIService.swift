//
//  APIService.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import Foundation

// MARK: - APIService 정의
// API 호출 동작을 수행하는 객체

protocol APIServiceInterface {
    
    func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void
    )
}

struct APIService: APIServiceInterface {
    
    // API 요청
    func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void) {
            guard let transPathURL = makeTransPathURL(start: start, end: end),
                  let url = URL(string: transPathURL) else {
                completion(.failure(APIServiceError.invalidURL))
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    completion(.failure(APIServiceError.requestFail))
                }
                guard let data = data else {
                    completion(.failure(APIServiceError.noData))
                    return
                }
                guard let transPathDTO = try? JSONDecoder().decode(TransPathDTO.self, from: data) else {
                    completion(.failure(APIServiceError.decodingError))
                    return
                }
                completion(.success(transPathDTO))
            }.resume()
    }
}

extension APIService {
    
    // API 요청 URL 생성
    func makeTransPathURL(
        start: XYCoordinate,
        end: XYCoordinate,
        resultSortType: ResultOrderType = .recommendPath,
        searchType: SearchType = .inCity,
        searchPathType: SearchPathType = .all
    ) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ODSAY_API_KEY") as? String else {
            return nil
        }
        var transPathURL = "https://api.odsay.com/v1/api/searchPubTransPathT?"
        transPathURL += "apiKey=\(apiKey)"
        transPathURL += "&output=json"
        transPathURL += "&SX=\(start.lonX)&SY=\(start.latY)"
        transPathURL += "&EX=\(end.lonX)&EY=\(end.latY)"
        transPathURL += "&OPT=\(resultSortType.rawValue)"
        transPathURL += "&SearchType=\(searchType.rawValue)"
        transPathURL += "&SearchPathType=\(searchPathType.rawValue)"
        return transPathURL
    }
}
