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
        input.startButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("start Button Tap")
            }
            .disposed(by: disposeBag)
        
        input.skipButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                print("skip Button Tap")
            }
            .disposed(by: disposeBag)
        
        
        let label: Driver<String> = .empty()
        let searchedResult: Observable<[EndPoint]> = .empty()
        
        return Output(
            textFieldLabel: label,
            searchedResult: searchedResult
        )
    }
}
