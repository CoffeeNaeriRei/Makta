//
//  APIService.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import Foundation

// MARK: - APIServiceInterface 정의
// API 호출 동작을 수행하는 APIService 객체의 인터페이스를 정의

protocol APIServiceInterface {
    func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void
    )
    func fetchSeoulRealtimeSubwayArrival(
        stationName: String,
        completion: @escaping (Result<SeoulRealtimeSubwayDTO, APIServiceError>) -> Void
    )
    func fetchSeoulRealtimeBusStationInfo(
        arsID: String,
        completion: @escaping (Result<SeoulRealtimeBusStationDTO, APIServiceError>) -> Void
    )
}

// MARK: - APIService 정의

struct APIService: APIServiceInterface {
    // 대중교통 환승경로 API 요청
    func fetchTransPathData(
        start: XYCoordinate,
        end: XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void
    ) {
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
    
    // 서울시 실시간 지하철 도착 정보 API 요청
    func fetchSeoulRealtimeSubwayArrival(
        stationName: String,
        completion: @escaping (Result<SeoulRealtimeSubwayDTO, APIServiceError>) -> Void
    ) {
        guard let seoulRealtimeSubwayURL = makeSeoulRealtimeSubwayURL(stationName: stationName),
              let url = URL(string: seoulRealtimeSubwayURL) else {
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
            guard let seoulRealtimeSubwayDTO = try? JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: data) else {
                completion(.failure(APIServiceError.decodingError))
                return
            }
            completion(.success(seoulRealtimeSubwayDTO))
        }.resume()
    }
    
    // 서울특별시 정류소정보조회 API 요청
    func fetchSeoulRealtimeBusStationInfo(
        arsID: String,
        completion: @escaping (Result<SeoulRealtimeBusStationDTO, APIServiceError>) -> Void
    ) {
        guard let seoulRealtimeBusStationURL = makeSeoulRealtimeBusStationURL(arsID: arsID),
              let url = URL(string: seoulRealtimeBusStationURL) else {
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
            guard let seoulRealtimeBusStationDTO = try? JSONDecoder().decode(SeoulRealtimeBusStationDTO.self, from: data) else {
                completion(.failure(APIServiceError.decodingError))
                return
            }
            completion(.success(seoulRealtimeBusStationDTO))
        }.resume()
    }
}

extension APIService {
    // [대중교통 환승경로 API] 요청 URL 생성
    func makeTransPathURL(
        start: XYCoordinate,
        end: XYCoordinate,
        resultSortType: ResultOrderType = .recommendPath, // 경로검색결과 정렬방식 - 0:추천경로|1:타입별정렬
        searchType: SearchType = .inCity, // 도시간|도시내 이동 선택 - 0:도시내
        searchPathType: SearchPathType = .all // 도시 내 경로수단 - 0:모두|1:지하철|2:버스
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
    
    // [서울시 실시간 지하철 도착 정보 API] 요청 URL 생성
    func makeSeoulRealtimeSubwayURL(
        stationName: String,
        startIdx: Int = 0, // 페이징 시작번호
        endIdx: Int = 15 // 페이징 끝번호
    ) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REALTIME_SUBWAY_API") as? String else {
            return nil
        }
        var seoulRealtimeSubwayURL = "http://swopenAPI.seoul.go.kr/api/subway/\(apiKey)/json/realtimeStationArrival"
        seoulRealtimeSubwayURL += "/\(startIdx)"
        seoulRealtimeSubwayURL += "/\(endIdx)"
        seoulRealtimeSubwayURL += "/\(stationName)"
        
        return seoulRealtimeSubwayURL
    }
    
    // [서울특별시 정류소정보조회 API] 요청 URL 생성
    func makeSeoulRealtimeBusStationURL(
        arsID: String // 정류소고유번호
    ) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REALTIME_BUS_STATION_API") as? String else {
            return nil
        }
        var seoulRealtimeBusStationURL = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid"
        seoulRealtimeBusStationURL += "?serviceKey=\(apiKey)"
        seoulRealtimeBusStationURL += "&arsId=\(arsID.removeHyphen())"
        seoulRealtimeBusStationURL += "&resultType=json"
        
        return seoulRealtimeBusStationURL
    }
}
