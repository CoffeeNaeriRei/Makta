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

enum OnboardingType {
    case enterFirst
    case enterToSettings
}

final class OnboardingViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: OnboardingView {
        view as! OnboardingView
    }
    // swiftlint: enable force_cast
    private let type: OnboardingType
    
    private let vm: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    init(_ vm: OnboardingViewModel, type: OnboardingType = .enterFirst) {
        self.vm = vm
        self.type = type
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
        view = OnboardingView(type == .enterFirst ? .enterFirst : .enterToSettings)
    }
    
    private func setup() {
        if type == .enterFirst {
            navigationItem.setHidesBackButton(true, animated: true)
        }
        navigationItem.title = type == .enterFirst ? "도착지 설정" : "도착지 수정"
        mainView.searchResultTableView.delegate = self
    }
    
    private func bind() {
        let textFieldChange = mainView.textField.rx.text.orEmpty
        let selected = mainView.searchResultTableView.rx.itemSelected
        let startButtonTap = mainView.startButton.rx.tap
        let skipButtonTap = mainView.skipButton.rx.tap
        
        let input = OnboardingViewModel.Input(
            textFieldChange: textFieldChange,
            searchedPointSelect: selected,
            startButtonTap: startButtonTap,
            skipButtonTap: skipButtonTap
        )
        
        let output = vm.transform(input: input)
        
        output.textFieldLabel
            .drive(mainView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.searchedResult
            .bind(to: mainView.searchResultTableView.rx.items) { tableView, row, item in
                let idx: IndexPath = .init(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(for: idx) as SearchResultCell
                cell.configure(with: item)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoaded.accept(())
    }
}

extension OnboardingViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension OnboardingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          view.endEditing(true)
      }
}

#if DEBUG
struct OnboardingViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let apiService = APIService()
            let locationService = LocationService()
            let makchaInfoUseCase = MakchaInfoUseCase(
                TransPathRepository(apiService),
                EndPointRepository(locationService, apiService)
            )
            return UINavigationController(
                rootViewController: OnboardingViewController(
                    OnboardingViewModel(makchaInfoUseCase)
                )
            )
            
        }
    }
}
#endif
