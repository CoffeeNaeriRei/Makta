//
//  BaseCoordinator.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

// MARK: - 코디네이터 구현을 위한 인터페이스
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ vc: UINavigationController) {
        self.navigationController = vc
    }
    
    func start() {
        print("App Coordiantor Start")
        goToMain()
        
    }
    
    deinit {
        print("App Coordinator Deinit")
    }
}

extension AppCoordinator {
    func goToMain() {
        let coordinator = MainCoordinator(navigationController)
        children.removeAll()
        children.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
