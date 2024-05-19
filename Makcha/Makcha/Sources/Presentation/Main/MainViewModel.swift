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

// MARK: - 메인 화면의 뷰모델 (막차 경로 불러오는 화면)

final class MainViewModel: ViewModelType {
    
    private let makchaInfoUseCase: MakchaInfoUseCase
    
    private let disposeBag = DisposeBag()
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let viewDidLoadEvent = PublishRelay<Void>() // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
        let settingButtonTap = PublishRelay<Void>() // [설정] 버튼 탭
        let starButtonTap = PublishRelay<Void>() // [즐겨찾기] 버튼 탭
        let resetToCurrentLocationTap = PublishRelay<Void>() // [현재 위치로 재설정] 버튼 탭
        let detailViewTap = PublishRelay<Int>() // [자세히보기] 탭
    }
    
    struct Output {
        let startTime: Driver<String> // 출발 시간 (현재 시간)
        let startLocation: Driver<String> // 출발지
        let destinationLocation: Driver<String> // 도착지
        let makchaPaths: Driver<[MakchaPath]> // 막차 경로 배열
        let realTimeArrivals: Driver<[RealtimeArrivalTuple]> // 실시간 도착 정보
    }
    
    func transform(input: Input) -> Output {
        // input
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
            })
            .disposed(by: disposeBag)
        
        // output
        let startTime = makchaInfoUseCase.makchaInfo
            .map { "\($0.startTimeStr) 출발" }
            .asDriver(onErrorJustReturn: "\(Date().endPointTimeString) 출발")
        
        let startLocation = makchaInfoUseCase.startPoint
            .map { "\($0.name)" }
            .asDriver(onErrorJustReturn: "출발지를 설정해주세요.")
        
        let destinationLocation = makchaInfoUseCase.destinationPoint
            .map { "\($0.name) "}
            .asDriver(onErrorJustReturn: "도착지를 설정해주세요.")
        
        let makchaPaths = makchaInfoUseCase.makchaInfo
            .map { $0.makchaPaths }
            .asDriver(onErrorJustReturn: [])
        
        let realtimeArrivals = makchaInfoUseCase.realtimeArrivals
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            startTime: startTime,
            startLocation: startLocation,
            destinationLocation: destinationLocation,
            makchaPaths: makchaPaths,
            realTimeArrivals: realtimeArrivals
        )
    }
}
