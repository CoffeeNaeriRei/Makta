//
//  KakaoAddressSearchResultDTO.swift
//  Makcha
//
//  Created by 김영빈 on 6/7/24.
//

import Foundation

// MARK: - 카카오 로컬 API의 주소검색 서비스 응답 결과 DTO
/// https://developers.kakao.com/docs/latest/ko/local/dev-guide#address-coord

struct KakaoAddressSearchResultDTO: Codable {
    let addresses: [KakaoAddressInfo]
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case addresses = "documents"
        case meta
    }
}

// 1개 주소에 대한 정보
struct KakaoAddressInfo: Codable {
    let address: KakaoAddress? // 지번 주소 정보
    let addressName: String? // 전체 지번 주소 or 전체 도로명 주소 (입력 형식에 따라 결정)
    let addressType: String? // REGION(지명) | ROAD(도로명) | REGION_ADDR(지번 주소) | ROAD_ADDR(도로명 주소)
    let roadAddress: KakaoRoadAddress? // 도로명 주소 정보
    let x: String? // 경도
    let y: String? // 위도
    
    enum CodingKeys: String, CodingKey {
        case address
        case addressName = "address_name"
        case addressType = "address_type"
        case roadAddress = "road_address"
        case x
        case y
    }
}

// 지번 주소 정보
struct KakaoAddress: Codable {
    let addressName: String // 전체 지번 주소
    let mainAddressNo: String // 지번 주번지
    let subAddressNo: String // 지번 부번지 (없을 경우 빈 문자열 "")
    let regionDepth1: String // 시/도 단위
    let regionDepth2: String // 구 단위
    let regionDepth3Detail: String // 동 단위 ex) 갈현2동
    let regionDepth3: String // 행정동 명칭 ex) 갈현동
    let x: String // 경도
    let y: String // 위도
    let bCode: String // 법정 코드
    let hCode: String // 행정 코드
    let isMountain: String // 산 여부 (Y/N)
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case regionDepth1 = "region_1depth_name"
        case regionDepth2 = "region_2depth_name"
        case regionDepth3Detail = "region_3depth_h_name"
        case regionDepth3 = "region_3depth_name"
        case x
        case y
        case bCode = "b_code"
        case hCode = "h_code"
        case isMountain = "mountain_yn"
    }
}

// 도로명 주소 정보
struct KakaoRoadAddress: Codable {
    let addressName: String // 전체 도로명 주소
    let postNo: String // 우편번호 (5자리)
    let buildingName: String // 건물 이름
    let roadName: String // 도로명
    let mainBuildingNo: String // 건물 본번
    let subBuildingNo: String // 건물 부번 (없을 경우 빈 문자열 "")
    let regionDepth1: String // 지역명1
    let regionDepth2: String // 지역명2
    let regionDepth3: String // 지역명3
    let x: String
    let y: String
    let isUnderground: String // 지하 여부 (Y/N)
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case postNo = "zone_no"
        case buildingName = "building_name"
        case roadName = "road_name"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case regionDepth1 = "region_1depth_name"
        case regionDepth2 = "region_2depth_name"
        case regionDepth3 = "region_3depth_name"
        case x
        case y
        case isUnderground = "underground_yn"
    }
}

struct Meta: Codable {
    let isEnd: Bool // 현재 페이지가 마지막 페이지인지
    let pageableCount: Int // totalCount 중 노출 가능 문서 수
    let totalCount: Int // 검색어로 검색된 문서 수
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
