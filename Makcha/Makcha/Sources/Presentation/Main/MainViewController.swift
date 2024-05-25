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
import RxDataSources
import SwiftUI

enum MainNavLink {
    case searchPath
    case detail
    case settings
    case remark
}

typealias SectionOfMainCard = SectionModel<String, MakchaPath>

final class MainViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: MainView {
        view as! MainView
    }
    // swiftlint: enable force_cast
    
    private let leftUIBarButtonItem = UIBarButtonItem()
    private let rightUIBarButtonItem = UIBarButtonItem()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>?
    
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
        pushNavigation(.searchPath)
//        print(mainViewModel.tempSections.value.count)
    }
    
    public override func loadView() {
        view = MainView()
    }
    
    private func setup() {
        view.backgroundColor = .white
        // NavigationLink Setting
        setupNavigationItems()
        setupCollectionView()
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
    
    private func setupCollectionView() {
        let collectionView = mainView.collectionView as? MainCollectionView
        dataSource = collectionView?.rxDataSource
    }
    
    private func bind() {
        let input = MainViewModel.Input(settingButtonTap: leftUIBarButtonItem.rx.tap,
                                        starButtonTap: rightUIBarButtonItem.rx.tap)

        let output = mainViewModel.transform(input: input)
        
        bindCollectionView()
        // MARK: 페이지 네비게이션 바인딩
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
        
        input.viewDidLoadEvent.accept(()) // 바인딩이 끝난 뒤에 viewDldLoad 이벤트 1회 발생
    }

    private func bindCollectionView() {
        guard let dataSource = dataSource else { return }
        
        // MARK: 어떻게 input으로 처리할 수 있을까요.. 혹은 input으로 처리를 해야할까요?!
        mainView.collectionView.rx.willDisplaySupplementaryView
            .withUnretained(self)
            .subscribe { _, event in
                if let header = event.supplementaryView as? MainCollectionHeaderCell {
                    header.resetButton.rx.tap
                        .withUnretained(self)
                        .subscribe { vc, _ in
                            vc.mainViewModel.resetToCurrentLocationTap()
                        }
                        .disposed(by: header.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        mainViewModel.tempSections
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func pushNavigation(_ link: MainNavLink) {
        switch link {
        case .searchPath:
            setupSheet()
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
