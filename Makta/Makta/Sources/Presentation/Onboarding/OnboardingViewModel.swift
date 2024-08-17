//
//  OnboardingViewModel.swift
//  Makcha
//
//  Created by yuncoffee on 7/22/24.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

final class OnboardingViewModel: ViewModelType {
    private let makchaInfoUseCase: MakchaInfoUseCase
    private let disposeBag = DisposeBag()
    weak var navigation: OnboardingNavigation?
    weak var settingsNavigation: SettingsNavigation?
    
    private let type: OnboardingType
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase, type: OnboardingType = .enterFirst) {
        self.makchaInfoUseCase = makchaInfoUseCase
        self.type = type
    }
    
    struct Input {
        let viewDidLoaded = PublishRelay<Void>()
        let textFieldChange: ControlProperty<String> // 텍스트필드 입력 변화
        let searchedPointSelect: ControlEvent<IndexPath> // 검색 결과 목록 중 하나 선택
        let startButtonTap: ControlEvent<Void> // 시작하기 버튼 탭
        let skipButtonTap: ControlEvent<Void> // 건너뛰기 버튼 탭
    }
    
    struct Output {
        let textFieldLabel: Driver<String>
        let searchedResult: Observable<[EndPoint]>
    }
    
    func transform(input: Input) -> Output {
        // input Change
        input.viewDidLoaded
            .withUnretained(self)
            .subscribe(onNext: { vm, _ in
                vm.makchaInfoUseCase.searchedStartPoints.onNext([])
                vm.makchaInfoUseCase.searchedDestinationPoints.onNext([])
            })
            .disposed(by: disposeBag)
        
        input.textFieldChange
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe { vm, text in
                if !text.isEmpty {
                    vm.makchaInfoUseCase.searchWithAddressText(isStartPoint: false, searchKeyword: text)
                }
            }
            .disposed(by: disposeBag)
        
        // collectionView Select
        input.searchedPointSelect
            .withUnretained(self)
            .subscribe { vm, collection in
                vm.makchaInfoUseCase.updatePointToSearchedAddress(idx: collection.row)
            }
            .disposed(by: disposeBag)
        
        input.startButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("start Button Tap")
                vm.makchaInfoUseCase.saveDefaultDestinationPoint()
                vm.makchaInfoUseCase.searchedStartPoints.onNext([])
                vm.makchaInfoUseCase.searchedDestinationPoints.onNext([])
                if vm.type == .enterFirst {
                    vm.goToMain(isSkip: false)
                } else {
                    vm.settingsNavigation?.showEditCompleteAlert()
                }
            }
            .disposed(by: disposeBag)
        
        input.skipButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("Skip Button Tap")
                vm.goToMain(isSkip: true)
            }
            .disposed(by: disposeBag)
        
        let label = makchaInfoUseCase.destinationPoint
            .map { $0.roadAddressName ?? $0.addressName }
            .asDriver(onErrorJustReturn: "")
            
        let searchedResult = makchaInfoUseCase.searchedDestinationPoints
        
        return Output(
            textFieldLabel: label,
            searchedResult: searchedResult
        )
    }
}

extension OnboardingViewModel: OnboardingNavigation {
    func goToMain(isSkip: Bool) {
        navigation?.goToMain(isSkip: isSkip)
    }
}
