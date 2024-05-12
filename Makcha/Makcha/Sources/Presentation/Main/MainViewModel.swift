//
//  MainViewModel.swift
//  Makcha
//
//  Created by 김영빈 on 5/10/24.
//

import RxRelay
import RxSwift

// MARK: - 메인 화면의 뷰모델 (막차 경로 불러오는 화면)

protocol MainViewModelType {
    
    // input부
    var viewDidLoadEvent: PublishRelay<Void> { get } // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
    var settingButtonTap: PublishRelay<Void> { get } // [설정] 버튼 탭
    var starButtonTap: PublishRelay<Void> { get } // [즐겨찾기] 버튼 탭
    var resetToCurrentLocationTap: PublishRelay<Void> { get } // [현재 위치로 재설정] 버튼 탭
    var detailViewTap: PublishRelay<Int> { get } // [자세히보기] 탭
    
    // output
    var startTime: BehaviorRelay<String> { get } // 출발 시간 (현재 시간)
    var startLocation: BehaviorRelay<String> { get } // 출발지
    var destinationLocation: BehaviorRelay<String> { get } // 도착지
    var makchaPaths: BehaviorRelay<[MakchaPath]> { get } // 막차 경로 배열
}

final class MainViewModel: MainViewModelType {
    
    // input
    let viewDidLoadEvent = PublishRelay<Void>()
    let settingButtonTap = PublishRelay<Void>()
    let starButtonTap = PublishRelay<Void>()
    let resetToCurrentLocationTap = PublishRelay<Void>()
    let detailViewTap = PublishRelay<Int>()
    
    // output
    let startTime = BehaviorRelay<String>(value: "출발시간(현재시간) 불러오기")
    let startLocation = BehaviorRelay<String>(value: "출발지 주소")
    let destinationLocation = BehaviorRelay<String>(value: "도착지 주소")
    let makchaPaths = BehaviorRelay<[MakchaPath]>(value: mockMakchaInfo.makchaPaths)
    
    private let makchaInfoUseCase: MakchaInfoUseCase
    
    private let disposeBag = DisposeBag()
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
        
        configureInput()
        createOutput()
    }
    
    private func configureInput() {
        
    }
    
    private func createOutput() {
        
    }
}
