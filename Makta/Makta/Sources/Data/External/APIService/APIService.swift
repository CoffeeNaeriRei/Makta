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
        destination: XYCoordinate,
        completion: @escaping (Result<TransPathDTOResponsable, APIServiceError>) -> Void
    )
    func fetchSeoulRealtimeSubwayArrival(
        stationName: String,
        completion: @escaping (Result<SeoulRealtimeSubwayDTO, APIServiceError>) -> Void
    )
    func fetchSeoulRealtimeBusStationInfo(
        arsID: String,
        completion: @escaping (Result<SeoulRealtimeBusStationDTO, APIServiceError>) -> Void
    )
    func fetchKakaoPlaceSearchResult(
        placeKeyword: String,
        completion: @escaping (Result<KakaoPlaceSearchResultDTO, APIServiceError>) -> Void
    )
    func fetchKakaoReverseGeocodingResult(
        lonX: String,
        latY: String,
        completion: @escaping (Result<KakaoReverseGeocodingResultDTO, APIServiceError>) -> Void
    )
}

// MARK: - APIService 정의

struct APIService: APIServiceInterface {
    // 대중교통 환승경로 API 요청
    func fetchTransPathData(
        start: XYCoordinate,
        destination: XYCoordinate,
        completion: @escaping (Result<TransPathDTOResponsable, APIServiceError>) -> Void
    ) {
        guard let transPathURL = makeTransPathURL(start: start, destination: destination),
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
            // TransPathDTO / TransPathErrorDTO 중 적절한 응답으로 디코딩
            if var transPathDTO = try? JSONDecoder().decode(TransPathDTO.self, from: data) {
                transPathDTO.type = .success
                completion(.success(transPathDTO))
                return
            } else if var transPathErrorDTO = try? JSONDecoder().decode(TransPathErrorDTO.self, from: data) {
                transPathErrorDTO.type = .error
                completion(.success(transPathErrorDTO))
                return
            }
            completion(.failure(APIServiceError.decodingError))
        }.resume()
    }
    
    // 서울시 실시간 지하철 도착 정보 API 요청
    func fetchSeoulRealtimeSubwayArrival(
        stationName: String,
        completion: @escaping (Result<SeoulRealtimeSubwayDTO, APIServiceError>) -> Void
    ) {
        guard let seoulRealtimeSubwayURL = makeSeoulRealtimeSubwayURL(stationName: stationName)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
    
    // 카카오 로컬 - 키워드로 장소 검색하기 API 요청
    func fetchKakaoPlaceSearchResult(
        placeKeyword: String,
        completion: @escaping (Result<KakaoPlaceSearchResultDTO, APIServiceError>) -> Void
    ) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_LOCAL_API") as? String,
              let kakaoPlaceSearchURL = makeKakaoPlaceSearchURL(keyword: placeKeyword)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: kakaoPlaceSearchURL) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        // 헤더 구성
        var requestURL = URLRequest(url: url)
        requestURL.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if error != nil {
                completion(.failure(APIServiceError.requestFail))
            }
            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }
            guard let kakaoPlaceSearchResultDTO = try? JSONDecoder().decode(KakaoPlaceSearchResultDTO.self, from: data) else {
                completion(.failure(APIServiceError.decodingError))
                return
            }
            completion(.success(kakaoPlaceSearchResultDTO))
        }.resume()
    }
    
    // 카카오 로컬 - 좌표로 주소 변환하기 API 요청
    func fetchKakaoReverseGeocodingResult(
        lonX: String,
        latY: String,
        completion: @escaping (Result<KakaoReverseGeocodingResultDTO, APIServiceError>) -> Void
    ) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_LOCAL_API") as? String,
              let kakaoReverseGeocodingURL = makeKakaoReverseGeocodingURL(lonX: lonX, latY: latY),
              let url = URL(string: kakaoReverseGeocodingURL) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        // 헤더 구성
        var requestURL = URLRequest(url: url)
        requestURL.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if error != nil {
                completion(.failure(APIServiceError.requestFail))
            }
            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }
            guard let kakaoReverseGeocodingResultDTO = try? JSONDecoder().decode(KakaoReverseGeocodingResultDTO.self, from: data) else {
                completion(.failure(APIServiceError.decodingError))
                return
            }
            completion(.success(kakaoReverseGeocodingResultDTO))
        }.resume()
    }
}

extension APIService {
    // [대중교통 환승경로 API] 요청 URL 생성
    func makeTransPathURL(
        start: XYCoordinate,
        destination: XYCoordinate,
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
        transPathURL += "&EX=\(destination.lonX)&EY=\(destination.latY)"
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
    /// arsID: 정류소고유번호
    func makeSeoulRealtimeBusStationURL(arsID: String) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REALTIME_BUS_STATION_API") as? String else {
            return nil
        }
        var seoulRealtimeBusStationURL = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid"
        seoulRealtimeBusStationURL += "?serviceKey=\(apiKey)"
        seoulRealtimeBusStationURL += "&arsId=\(arsID.removeHyphen())"
        seoulRealtimeBusStationURL += "&resultType=json"
        
        return seoulRealtimeBusStationURL
    }
    
    // [카카오 로컬 API - 키워드로 장소 검색하기] 요청 URL 생성
    func makeKakaoPlaceSearchURL(
        keyword placeKeywordQuery: String, // 검색 질의어
        page: Int = 1, // 결과 페이지 번호
        size: Int = 15 // 한 페이지에 보여질 문서 개수
    ) -> String? {
        var kakaoPlaceSearchURL = "https://dapi.kakao.com/v2/local/search/"
        kakaoPlaceSearchURL += "keyword.json"
        kakaoPlaceSearchURL += "?query=\(placeKeywordQuery)"
        kakaoPlaceSearchURL += "&page=\(page)"
        kakaoPlaceSearchURL += "&size=\(size)"
        
        return kakaoPlaceSearchURL
    }
    
    // [카카오 로컬 API - 좌표로 주소 변환하기] 요청 URL 생성
    private func makeKakaoReverseGeocodingURL(lonX: String, latY: String) -> String? {
        var kakaoReverseGeocodingURL = "https://dapi.kakao.com/v2/local/geo/"
        kakaoReverseGeocodingURL += "coord2address.json"
        kakaoReverseGeocodingURL += "?x=\(lonX)"
        kakaoReverseGeocodingURL += "&y=\(latY)"
        
        return kakaoReverseGeocodingURL
    }
}
