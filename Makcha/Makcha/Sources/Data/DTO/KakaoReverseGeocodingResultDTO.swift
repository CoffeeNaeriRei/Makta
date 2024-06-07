//
//  KakaoReverseGeocodingResultDTO.swift
//  Makcha
//
//  Created by 김영빈 on 6/8/24.
//

import Foundation

// MARK: - 카카오 로컬 API의 [좌표로 주소 변환하기] 서비스 응답 결과 DTO (리버스 지오코딩)
/// https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-keyword

struct KakaoReverseGeocodingResultDTO: Codable {
    let results: [KakaoAddressInfo] // 응답 결과
    let meta: KakaoReverseGeocodingMeta // 응답 관련 정보
    
    enum CodingKeys: String, CodingKey {
        case results = "documents"
        case meta
    }
}

struct KakaoAddressInfo: Codable {
    let roadAddress: KakaoRoadAddress // 도로명 주소 상세 정보
    let address: KakaoAddress // 지번 주소 상세 정보
    
    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

// 도로명 주소 상세 정보
struct KakaoRoadAddress: Codable {
    let addressName: String // 전체 도로명 주소
    let region1Depth: String // 지역 1Depth (시/도)
    let region2Depth: String // 지역 2Depth (구)
    let region3Depth: String // 지역 3Depth명 (면)
    let roadName: String // 도로명
    let isUnderground: String // 지하 여부 (Y/N)
    let mainBuildingNo: String // 건물 본번
    let subBuildingNo: String // 건물 부번, 없을 경우 빈 문자열("") 반환
    let buildingName: String // 건물 이름
    let postNo: String // // 우편번호 (5자리)
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1Depth = "region_1depth_name"
        case region2Depth = "region_2depth_name"
        case region3Depth = "region_3depth_name"
        case roadName = "road_name"
        case isUnderground = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case postNo = "zone_no"
    }
}

// 지번 주소 상세 정보
struct KakaoAddress: Codable {
    let addressName: String // 전체 지번 주소
    let region1Depth: String // 지역 1Depth명 (시/도)
    let region2Depth: String // 지역 2Depth명 (구)
    let region3Depth: String // 지역 3Depth명 (동)
    let isMountain: String // 산 여부 (Y/N)
    let mainAddressNo: String // 지번 주 번지
    let subAddressNo: String // 지번 부 번지, 없을 경우 빈 문자열("") 반환
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1Depth = "region_1depth_name"
        case region2Depth = "region_2depth_name"
        case region3Depth = "region_3depth_name"
        case isMountain = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
    }
}

struct KakaoReverseGeocodingMeta: Codable {
    let totalCount: Int // 변환된 지번 주소 및 도로명 주소의 개수, 0 또는 1
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
