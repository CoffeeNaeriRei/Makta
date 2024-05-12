//
//  MainViewModel.swift
//  Makcha
//
//  Created by yuncoffee on 5/12/24.
//

import Foundation

import RxRelay
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    
    private let makchaInfoUseCase: MakchaInfoUseCase
    
    private let disposeBag = DisposeBag()
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let resetCoordinateAction: ControlEvent<Void>
        let worldButtonTap: ControlEvent<Void>
        
        let viewDidLoadEvent = PublishRelay<Void>() // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
        let settingButtonTap = PublishRelay<Void>() // [설정] 버튼 탭
        let starButtonTap = PublishRelay<Void>() // [즐겨찾기] 버튼 탭
        let resetToCurrentLocationTap = PublishRelay<Void>() // [현재 위치로 재설정] 버튼 탭
        let detailViewTap = PublishRelay<Int>() // [자세히보기] 탭
    }
    
    struct Output {
        let currentTime: Driver<String>
        let worldText: Driver<String>
        
        let startTime = BehaviorRelay<String>(value: "출발시간(현재시간) 불러오기") // 출발 시간 (현재 시간)
        let startLocation = BehaviorRelay<String>(value: "출발지 주소") // 출발지
        let destinationLocation = BehaviorRelay<String>(value: "도착지 주소") // 도착지
        let makchaPaths = BehaviorRelay<[MakchaPath]>(value: mockMakchaInfo.makchaPaths) // 막차 경로 배열
    }
    
    func transform(input: Input) -> Output {
        let currentTime = input.resetCoordinateAction
            .map { 
                print("변환")
                return Date().description
            }
            .asDriver(onErrorJustReturn: "")
        
        let worldText = input.worldButtonTap
            .map {"World"}
            .asDriver(onErrorJustReturn: "")
        
        return Output(currentTime: currentTime, worldText: worldText)
    }
}
