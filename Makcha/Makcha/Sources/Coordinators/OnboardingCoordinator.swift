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
        if isSkip {
            let key = DestinationKey.defaultDestination.rawValue
            UserDefaults.standard.setValue("", forKey: key)
        }
        UserDefaults.standard.setValue(true, forKey: .isSkipOnboarding)
        
        removeAll()
        let coordinator = MainCoordinator(navigationController)
        addChild(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
