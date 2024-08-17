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
    func showSheet(_ height: CGFloat)
    func pullDownSheet()
    func pullUpSheet()
    func goToDetails(_ makchaIdx: Int, with data: MakchaCellData, path: (String, String))
}

final class MainCoordinator: BaseCoordinator {
    // pullDownSheet를 위한 참조
    var searchPathViewController: SearchPathViewController?
    
    // MARK: Navigation 처리
    override func start() {
        super.start()
        
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        
        let makchaInfoUseCase = appCoordinator.makchaInfoUseCase
        let mainVM = MainViewModel(makchaInfoUseCase)
        let searchPathVM = SearchPathViewModel(makchaInfoUseCase)
        
        self.searchPathViewController = SearchPathViewController(searchPathVM)
        self.searchPathViewController?.navigation = self
        
        mainVM.navigation = self
        let mainViewController = MainViewController(mainVM)
        navigationController.pushViewController(mainViewController, animated: true)
    }
}

extension MainCoordinator: MainNavigation {
    func goToSettings() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        navigationController.dismiss(animated: true) // 검색 시트 dismiss
        let makchaInfoUseCase = appCoordinator.makchaInfoUseCase
        
        let settingsCoord = SettingsCoordinator(navigationController, makchaInfoUseCase: makchaInfoUseCase)
        addChild(settingsCoord)
        settingsCoord.parentCoordinator = self
        settingsCoord.start()
    }
    
    func goToRemark() {
        navigationController.dismiss(animated: true)
        navigationController.pushViewController(RemarkViewController(), animated: true)
    }
    
    func showSheet(_ height: CGFloat) {
        guard let searchPathSheet = self.searchPathViewController else { return }
        
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
            sheet.delegate = searchPathSheet
        }
        navigationController.present(searchPathSheet, animated: true)
    }
        
    func pullUpSheet() {
        guard let sheet = searchPathViewController?.sheetPresentationController else { return }
        sheet.animateChanges {
            sheet.selectedDetentIdentifier = .large
        }
    }
    
    /// SearchPathView 시트를 "initDent" 크기의 Dent로 내려준다.
    func pullDownSheet() {
        guard let sheet = searchPathViewController?.sheetPresentationController else { return }
        sheet.animateChanges {
            sheet.selectedDetentIdentifier = UISheetPresentationController.Detent.Identifier("initDent")
        }
    }
    
    func goToDetails(_ makchaIdx: Int, with data: MakchaCellData, path: (String, String)) {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        
        let vc = DetailViewController(makchaIdx: makchaIdx, data: data, path: path)
        vc.makchaInfoUseCase = appCoordinator.makchaInfoUseCase
        navigationController.dismiss(animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
}
