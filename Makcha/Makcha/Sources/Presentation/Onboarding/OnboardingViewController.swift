//
//  OnboardingViewController.swift
//  Makcha
//
//  Created by yuncoffee on 7/22/24.
//

import Foundation
import UIKit
import SwiftUI

import RxSwift

/*
 - 여기로 오게 되는 경우?
 맨 처음임 ㅇㅇ
 */

final class OnboardingViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: OnboardingView {
        view as! OnboardingView
    }
    // swiftlint: enable force_cast
    
    private let vm: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    init(_ vm: OnboardingViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    override func loadView() {
        view = OnboardingView()
    }
    
    private func setup() {
        navigationItem.title = "도착지 설정"
    }
    
    private func bind() {
        let textFieldChange = mainView.textField.rx.text.orEmpty
        let selected = mainView.searchResultTableView.rx.itemSelected
        let startButtonTap = mainView.startButton.rx.tap
        let skipButtonTap = mainView.skipButton.rx.tap
        
        let output = vm.transform(
            input: .init(
                textFieldChange: textFieldChange,
                searchedPointSelect: selected,
                startButtonTap: startButtonTap,
                skipButtonTap: skipButtonTap
            )
        )
        
        output.textFieldLabel
            .drive(mainView.textField.rx.text)
            .disposed(by: disposeBag)
    }
}

#if DEBUG
struct OnboardingViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let apiService = APIService()
            let locationService = LocationService()
            let onbardingUseCase = OnboardingUseCase(
                TransPathRepository(apiService),
                EndPointRepository(locationService, apiService)
            )
            return UINavigationController(
                rootViewController: OnboardingViewController(
                    OnboardingViewModel(onbardingUseCase)
                )
            )
            
        }
    }
}
#endif
