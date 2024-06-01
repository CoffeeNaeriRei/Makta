//
//  MainViewModel.swift
//  Makcha
//
//  Created by yuncoffee on 5/12/24.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

// MARK: - 메인 화면의 뷰모델 (막차 경로 불러오는 화면)
final class MainViewModel: ViewModelType {
    private let makchaInfoUseCase: MakchaInfoUseCase
    private let disposeBag = DisposeBag()
    
    // 임시로 MainCollectionView의 DataSource를 채우기 위한 프로퍼티
    // 추후 명칭 변경 필요.
    var tempSections = BehaviorRelay(value: [SectionOfMainCard]())
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let viewDidLoadEvent = PublishRelay<Void>() // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
        let settingButtonTap: ControlEvent<Void> // [설정] 버튼 탭
        let starButtonTap: ControlEvent<Void> // [즐겨찾기] 버튼 탭
        // 자세히 보기 클릭 시, 현재 위치로 재설정 클릭 시 이벤트 CollectionViewBinding으로 위치 변경
    }
    
    struct Output {
        let startLocation: Driver<String> // 출발지
        let destinationLocation: Driver<String> // 도착지
    }
    
    func transform(input: Input) -> Output {
        // input
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vm, _ in
                vm.makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
            }
            .disposed(by: disposeBag)
        
        input.settingButtonTap
            .withUnretained(self)
            .subscribe { _, _ in
                print("Setting Link Click")
            }
            .disposed(by: disposeBag)
        
        input.starButtonTap
            .withUnretained(self)
            .subscribe { _, _ in
                print("Star Link Click")
            }
            .disposed(by: disposeBag)

        // MARK: makchaInfo 데이터 처리
        makchaInfoUseCase.makchaSectionModel
            .withUnretained(self)
            .subscribe(onNext: {
                $0.tempSections.accept([.init(model: $1.startTimeStr, items: $1.makchaCellData)])
            })
            .disposed(by: disposeBag)
 
        let startLocation = makchaInfoUseCase.startPoint
            .map { "\($0.name)" }
            .asDriver(onErrorJustReturn: "출발지를 설정해주세요.")
        
        let destinationLocation = makchaInfoUseCase.destinationPoint
            .map { "\($0.name) "}
            .asDriver(onErrorJustReturn: "도착지를 설정해주세요.")
        
        return Output(
            startLocation: startLocation,
            destinationLocation: destinationLocation
        )
    }
    
    // 현재 위치 재설정 버튼 클릭시 이벤트 처리를 위한 메서드
    func resetToCurrentLocationTap() {
        tempSections.accept([])
        makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
    }
}
