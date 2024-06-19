//
//  MainViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import SwiftUI
import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: MainView {
        view as! MainView
    }
    // swiftlint: enable force_cast
    
    private let mainViewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfMainCard>?
    
    private let leftUIBarButtonItem = UIBarButtonItem()
    private let rightUIBarButtonItem = UIBarButtonItem()

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
        setupSheet()
    }
    
    public override func loadView() {
        view = MainView()
    }
    
    private func setup() {
        view.backgroundColor = .cf(.grayScale(.white))
        setupNavigationItems()
        setupCollectionView()
    }
        
    private func bind() {
        let input = MainViewModel.Input(
            settingButtonTap: leftUIBarButtonItem.rx.tap,
            starButtonTap: rightUIBarButtonItem.rx.tap,
            startPointTextFieldChange: nil,
            destinationPointTextFieldChange: nil,
            searchedPointSelect: nil,
            destinationPointResetButtonTap: nil
        )

        _ = mainViewModel.transform(input: input)

        bindCollectionView()
        input.viewDidLoadEvent.accept(()) // 바인딩이 끝난 뒤에 viewDldLoad 이벤트 1회 발생
    }
}

// MARK: 메인 뷰 내 컬렉션 뷰 설정 관련
extension MainViewController: MainCollectionViewDelegate {
    private func setupCollectionView() {
        let collectionView = mainView.collectionView as? MainCollectionView
        dataSource = collectionView?.rxDataSource
        collectionView?.mainCollectionViewDelegate = self
    }
    
    private func bindCollectionView() {
        guard let dataSource = dataSource else { return }
        
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
    
    func goToDetails(_ indexPath: IndexPath) {
        mainViewModel.goToDetails(indexPath)
    }
}

// MARK: Navigation 처리 관련
extension MainViewController {
    private func setupNavigationItems() {
        let _title = "막차정보"
        let _leftBarButtonImage = UIImage(systemName: "gearshape")?
            .withTintColor(.cf(.grayScale(.gray700)), renderingMode: .alwaysOriginal)
        let _rightBarButtonImage = UIImage(systemName: "star")?
            .withTintColor(.cf(.grayScale(.gray700)), renderingMode: .alwaysOriginal)
        
        leftUIBarButtonItem.title = "Link to Setting"
        leftUIBarButtonItem.image = _leftBarButtonImage
        rightUIBarButtonItem.title = "Link to Remark"
        rightUIBarButtonItem.image = _rightBarButtonImage
        
        navigationItem.title = _title
        navigationItem.leftBarButtonItem = leftUIBarButtonItem
        navigationItem.rightBarButtonItem = rightUIBarButtonItem
    }
    
    private func setupSheet() {
        mainViewModel.showSheet(185 - self.mainView.safeAreaInsets.bottom, with: mainViewModel)
    }
}

#if DEBUG
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let apiService = APIService()
            let locationService = LocationService()
            
            return UINavigationController(
                rootViewController: MainViewController(
                    MainViewModel(
                        MakchaInfoUseCase(
                            TransPathRepository(apiService),
                            EndPointRepository(locationService, apiService)
                        )
                    )
                )
            )
        }
    }
}
#endif
