//
//  BaseCoordinator.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

protocol AppNavigation: AnyObject {
    func goToMain()
}

// MARK: - 코디네이터 구현을 위한 인터페이스
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

// MARK: - 기본 코디네이터 구현
class BaseCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(_ vc: UINavigationController) {
        self.navigationController = vc
    }
    
    func start() {}
    
    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        children = children.filter { $0 !== coordinator }
    }
    
    func removeAll() {
        children = []
    }
}

final class AppCoordinator: BaseCoordinator {
    private var isSkippedOnboarding = UserDefaults.standard.bool(forKey: .isSkipOnboarding)
    
    let apiService: APIServiceInterface
    let locationService: LocationService
    
    let transPathRepository: TransPathRepositoryProtocol
    let endPointRepository: EndPointRepositoryProtocol
    
    let makchaInfoUseCase: MakchaInfoUseCase
    
    override init(_ vc: UINavigationController) {
        self.apiService = APIService()
        self.locationService = LocationService()
        self.transPathRepository = TransPathRepository(apiService)
        self.endPointRepository = EndPointRepository(locationService, apiService)
        self.makchaInfoUseCase = MakchaInfoUseCase(transPathRepository, endPointRepository)
        super.init(vc)
    }
    
    override func start() {
        super.start()
        if isSkippedOnboarding {
            goToMain()
        } else {
            goToOnboarding()
        }
    }
    
    deinit {
        print("App Coordinator Deinit")
    }
}

extension AppCoordinator: AppNavigation {
    func goToMain() {
        removeAll()
        let coordinator = MainCoordinator(navigationController)
        addChild(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func goToOnboarding() {
        removeAll()
        let coordinator = OnboardingCoordinator(navigationController)
        addChild(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
