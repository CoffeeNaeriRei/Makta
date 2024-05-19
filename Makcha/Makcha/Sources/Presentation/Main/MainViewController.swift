//
//  MainViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum MainNavLink {
    case searchPath
    case detail
    case settings
    case remark
}

final class MainViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: MainView {
        view as! MainView
    }
    // swiftlint: enable force_cast
    
    private let leftUIBarButtonItem = UIBarButtonItem()
    private let rightUIBarButtonItem = UIBarButtonItem()
    
    private let mainViewModel: MainViewModel
    
    private let disposeBag = DisposeBag()
    
    init(_ mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sheet Setting
        setupSheet()
    }
    
    public override func loadView() {
        view = MainView()
    }
    
    private func setup() {
        view.backgroundColor = .white
        // NavigationLink Setting
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        let _title = "막차정보"
        let _leftBarButtonImage = UIImage(systemName: "gearshape")?
            .withTintColor(UIColor(Color.cf(.grayScale(.gray700))), renderingMode: .alwaysOriginal)
        let _rightBarButtonImage = UIImage(systemName: "star")?
            .withTintColor(UIColor(Color.cf(.grayScale(.gray700))), renderingMode: .alwaysOriginal)
        
        leftUIBarButtonItem.title = "Link to Setting"
        leftUIBarButtonItem.image = _leftBarButtonImage
        rightUIBarButtonItem.title = "Link to Remark"
        rightUIBarButtonItem.image = _rightBarButtonImage
        
        navigationItem.title = _title
        navigationItem.leftBarButtonItem = leftUIBarButtonItem
        navigationItem.rightBarButtonItem = rightUIBarButtonItem
    }
    
    private func setupSheet() {
        let searchPathSheet = SearchPathViewController()
        
        let initDent: UISheetPresentationController.Detent = .custom(identifier: .init("initDent")) { _ in
            185 - self.mainView.safeAreaInsets.bottom
        }
        
        if let sheet = searchPathSheet.sheetPresentationController {
            sheet.detents = [initDent, .large()]
            sheet.largestUndimmedDetentIdentifier = initDent.identifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.presentedViewController.isModalInPresentation = true
        }
        present(searchPathSheet, animated: true)
    }
    
    private func bind() {
        let input = MainViewModel.Input(settingButtonTap: leftUIBarButtonItem.rx.tap, 
                                        starButtonTap: rightUIBarButtonItem.rx.tap)
        input.settingButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                vc.pushNavigation(.settings)
            }
            .disposed(by: disposeBag)
        
        input.starButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                vc.pushNavigation(.remark)
            }
            .disposed(by: disposeBag)
        
        let output = mainViewModel.transform(input: input)
        
        output.realTimeArrivals // 실시간 도착정보 뷰 확인용
            .map {
                if let time = $0[0].first {
                    return String(time)
                } else {
                    return ""
                }
            }
            .drive(mainView.currentTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.makchaPaths
            .map { $0.count.description }
            .drive(mainView.currentPathCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent.accept(()) // 바인딩이 끝난 뒤에 viewDldLoad 이벤트 1회 발생
    }
    
    private func pushNavigation(_ link: MainNavLink) {
        switch link {
        case .searchPath:
            print("Navigation To")
        case .detail:
            print("Navigation To")
        case .settings:
            navigationController?.dismiss(animated: true)
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        case .remark:
            navigationController?.dismiss(animated: true)
            navigationController?.pushViewController(RemarkViewController(), animated: true)
        }
    }
}

#if DEBUG
import SwiftUI
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            UINavigationController(
                rootViewController: MainViewController(
                    MainViewModel(
                        MakchaInfoUseCase(
                            TransPathRepository(APIService()),
                            EndPointRepository(LocationService())
                        )
                    )
                )
            )
        }
    }
}
#endif
