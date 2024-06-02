//
//  MainCoordinator.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ vc: UINavigationController) {
        self.navigationController = vc
    }
    
    // MARK: Navigation 처리
    func start() {
        let vc = MainViewController(
            MainViewModel(
                MakchaInfoUseCase(
                    TransPathRepository(APIService()),
                    EndPointRepository(LocationService())
                )
            )
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
}
