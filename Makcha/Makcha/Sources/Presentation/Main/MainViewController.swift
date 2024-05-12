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

final class MainViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: MainView {
        view as! MainView
    }
    // swiftlint: enable force_cast
    
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
    
    public override func loadView() {
        view = MainView()
    }
    
    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "막차정보"
    }
    
    private func bind() {
        let input = MainViewModel.Input(resetCoordinateAction: mainView.button1.rx.tap,
                                        worldButtonTap: mainView.button2.rx.tap)
        let output = mainViewModel.transform(input: input)
       
        output.currentTime
            .drive(mainView.currentTimeLabel.rx.text)
            .disposed(by: disposeBag)
        output.worldText.drive(mainView.currentTimeLabel.rx.text)
            .disposed(by: disposeBag)
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
