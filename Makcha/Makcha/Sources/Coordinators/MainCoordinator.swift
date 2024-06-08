//
//  MainCoordinator.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

// MARK: 메인 화면에서 네비게이션처리를 위한 인터페이스
protocol MainNavigation: AnyObject {
    func goToSettings()
    func goToRemark()
    func showSheet(_ height: CGFloat, with vm: MainViewModel)
    func goToDetails(with data: MakchaCellData)
}

final class MainCoordinator: BaseCoordinator {
    // MARK: Navigation 처리
    override func start() {
        super.start()
        
        let apiService = APIService()
        let locationService = LocationService()
        
        let vm = MainViewModel(
            MakchaInfoUseCase(
                TransPathRepository(apiService),
                EndPointRepository(locationService, apiService)
            )
        )
        vm.navigation = self
        let vc = MainViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: MainNavigation {
    func goToSettings() {
        print("MainCoordinator에서 세팅 네비게이션 호출")
        navigationController.dismiss(animated: true)
        navigationController.pushViewController(SettingsViewController(), animated: true)
    }
    
    func goToRemark() {
        print("MainCoordinator에서 별 네비게이션 호출")
        navigationController.dismiss(animated: true)
        navigationController.pushViewController(RemarkViewController(), animated: true)
    }
    
    func showSheet(_ height: CGFloat, with vm: MainViewModel) {
        let searchPathSheet = SearchPathViewController(vm: vm)
        
        let customDent: UISheetPresentationController.Detent = .custom(identifier: .init("initDent")) { _ in
            height
        }

        if let sheet = searchPathSheet.sheetPresentationController {
            sheet.detents = [customDent, .large()]
            sheet.largestUndimmedDetentIdentifier = customDent.identifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.presentedViewController.isModalInPresentation = true
        }
        navigationController.present(searchPathSheet, animated: true)
    }
    
    func goToDetails(with data: MakchaCellData) {
        navigationController.dismiss(animated: true)
        navigationController.pushViewController(DetailViewController(data: data), animated: true)
    }
}
