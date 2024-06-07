//
//  KakaoPlaceSearchResultDTO.swift
//  Makcha
//
//  Created by 김영빈 on 6/7/24.
//

import Foundation

// MARK: - 카카오 로컬 API의 [키워드로 장소 검색하기] 서비스 응답 결과 DTO
/// https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-keyword

struct KakaoPlaceSearchResultDTO: Codable {
    let places: [KakaoPlace] // 응답 결과 (장소 데이터의 배열)
    let meta: Meta // 응답 관련 정보
    
    enum CodingKeys: String, CodingKey {
        case places = "documents"
        case meta
    }
}

struct KakaoPlace: Codable {
    let id: String // 장소 ID
    let categoryGroupCode: String // 중요 카테고리만 그룹핑한 카테고리 그룹 코드
    let categoryGroupName: String // 중요 카테고리만 그룹핑한 카테고리 그룹명
    let categoryName: String // 카테고리 이름
    let addressName: String // 전체 지번 주소
    let roadAddressName: String // 전체 도로명 주소
    let placeName: String // 장소명, 업체명
    let phoneNum: String // 전화번호
    let placeURL: String // 장소 상세페이지 URL
    let x: String // 경도(longitude)
    let y: String // 위도(latitude)
    let distance: String //  중심좌표까지의 거리 (단, x,y 파라미터를 준 경우에만 존재.) (단위 meter)
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case placeName = "place_name"
        case phoneNum = "phone"
        case placeURL = "place_url"
        case x
        case y
        case distance
    }
}

struct Meta: Codable {
    let isEnd: Bool // 현재 페이지가 마지막 페이지인지
    let pageableCount: Int // total_count 중 노충 가능 문서 수 (최대: 45)
    let totalCount: Int // 검색어에 검색된 문서 수
    let sameName: SameName // 질의어의 지역 및 키워드 분석 정보
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case sameName = "same_name"
    }
}

struct SameName: Codable {
    let keyword: String // 질의어에서 지역 정보를 제외한 키워드 - 예) '중앙로 맛집' 에서 '맛집'
    let region: [String] // 질의어에서 인식된 지역의 리스트 - 예) '중앙로 맛집' 에서 중앙로에 해당하는 지역 리스트
    let selectedRegion: String // 인식된 지역 리스트 중, 현재 검색에 사용된 지역 정보
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case region
        case selectedRegion = "selected_region"
    }
}
