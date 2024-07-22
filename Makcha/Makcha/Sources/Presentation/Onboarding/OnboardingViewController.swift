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
    
    private let vm: OnboardingViewModel
    
    init(_ vm: OnboardingViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Onboarding 시작!")
        view.backgroundColor = .gray
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
