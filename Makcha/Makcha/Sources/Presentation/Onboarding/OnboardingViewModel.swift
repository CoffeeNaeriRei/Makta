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
    private let onboardingUseCase: OnboardingUseCase
    private let disposeBag = DisposeBag()
    weak var navigation: OnboardingNavigation?
    
    init(_ onboardingUseCase: OnboardingUseCase) {
        self.onboardingUseCase = onboardingUseCase
    }
    
    struct Input {
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
        input.textFieldChange
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { vm, text in
                if !text.isEmpty {
                    vm.onboardingUseCase.searchWithAddressText(searchKeyword: text)
                }
            }
            .disposed(by: disposeBag)
        
        // collectionView Select
        input.searchedPointSelect
            .withUnretained(self)
            .subscribe { vm, collection in
                vm.onboardingUseCase.updatePointToSearchedAddress(idx: collection.row)
            }
            .disposed(by: disposeBag)
        
        input.startButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("start Button Tap")
                vm.onboardingUseCase.saveDefaultDestinationPoint()
                vm.goToMain(isSkip: false)
            }
            .disposed(by: disposeBag)
        
        input.skipButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("Skip Button Tap")
                vm.goToMain(isSkip: true)
            }
            .disposed(by: disposeBag)
         
        let label = onboardingUseCase.destinationPoint
            .map { $0.roadAddressName ?? $0.addressName}
            .asDriver(onErrorJustReturn: "")
            
        let searchedResult = onboardingUseCase.searchedDestinationPoints
        
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
