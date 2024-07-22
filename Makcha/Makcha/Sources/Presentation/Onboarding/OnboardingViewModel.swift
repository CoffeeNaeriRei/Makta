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

final class OnboardingViewModel {
    private let onboardingUseCase: OnboardingUseCase
    private let disposeBag = DisposeBag()
    weak var navigation: OnboardingNavigation?
    
    init(_ onboardingUseCase: OnboardingUseCase) {
        self.onboardingUseCase = onboardingUseCase
    }
}
