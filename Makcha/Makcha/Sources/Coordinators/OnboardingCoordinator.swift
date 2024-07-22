//
//  OnboardingCoordinator.swift
//  Makcha
//
//  Created by yuncoffee on 7/22/24.
//

import Foundation
import UIKit

protocol OnboardingNavigation: AnyObject {
    func goToMain(isSkip: Bool)
}

final class OnboardingCoordinator: BaseCoordinator {
    private let apiService = APIService()
    private let locationService = LocationService()
    
    override func start() {
        super.start()
        let useCase = OnboardingUseCase(TransPathRepository(apiService), EndPointRepository(locationService, apiService))
        let vm = OnboardingViewModel(useCase)
        
        vm.navigation = self
        let vc = OnboardingViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension OnboardingCoordinator: OnboardingNavigation {
    func goToMain(isSkip: Bool) {
        var isSkippedOnboarding = isSkip
        navigationController.dismiss(animated: true)
        print("이동 ㅇㅇ")
    }
}
