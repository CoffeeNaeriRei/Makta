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
    override func start() {
        super.start()
        
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        
        let makchaInfoUseCase = appCoordinator.makchaInfoUseCase
        let onboardingVM = OnboardingViewModel(makchaInfoUseCase)
        onboardingVM.navigation = self
        
        let onboardingVC = OnboardingViewController(onboardingVM)
        navigationController.pushViewController(onboardingVC, animated: false)
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
        let mainCoordinator = MainCoordinator(navigationController)
        addChild(mainCoordinator)
        mainCoordinator.parentCoordinator = parentCoordinator
        mainCoordinator.start()
    }
}
