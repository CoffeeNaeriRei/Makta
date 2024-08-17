//
//  SettingsCoordinator.swift
//  Makta
//
//  Created by 김영빈 on 8/16/24.
//

import Foundation
import MessageUI
import UIKit

protocol SettingsNavigation: AnyObject {
    func goToDestinationEdit()
    func showEditCompleteAlert()
    func showSettingsAppOpenAlert()
    func showMailInquirySheet()
    func showCannotOpenMailAppAlert()
    func goBack()
}

final class SettingsCoordinator: BaseCoordinator {
    
    private let makchaInfoUseCase: MakchaInfoUseCase
    
    init(_ vc: UINavigationController, makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
        super.init(vc)
    }
    
    override func start() {
        super.start()
        
        let settingsVC = SettingsViewController()
        settingsVC.navigation = self
        navigationController.pushViewController(settingsVC, animated: true)
    }
}

extension SettingsCoordinator: SettingsNavigation {
    /// 기본 도착지 설정으로 이동
    func goToDestinationEdit() {
        let onboardingVM = OnboardingViewModel(makchaInfoUseCase, type: .enterToSettings)
        onboardingVM.settingsNavigation = self
        let onboardingVC = OnboardingViewController(onboardingVM, type: .enterToSettings)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    /// 도착지 수정 완료 알럿
    func showEditCompleteAlert() {
        let alert = UIAlertController(title: "도착지 수정이 완료되었습니다.", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.goBack()
        }
        alert.addAction(confirm)
        navigationController.present(alert, animated: true)
    }
    
    /// [설정] 앱 열기
    func showSettingsAppOpenAlert() {
        let alert = UIAlertController(title: "⚙️ [설정] 앱으로 이동", message: "위치 권한의 수정은 [설정] 앱에서만 가능합니다.", preferredStyle: .alert)
        let move = UIAlertAction(title: "이동하기", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(move)
        alert.addAction(cancel)
        navigationController.present(alert, animated: true)
    }
    
    /// 이메일 문의 화면 띄우기
    func showMailInquirySheet() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setToRecipients(["rei1998@naver.com"])
            composeVC.setSubject("[막타] 앱 관련 문의 메일")
            composeVC.setMessageBody("문의하실 내용을 마음껏 작성해주세요 !\n피드백은 적극적으로 반영하겠습니다:)", isHTML: false)
            
            navigationController.present(composeVC, animated: true)
        } else {
            showCannotOpenMailAppAlert()
        }
    }
    
    /// [Mail] 앱 오픈 불가 알럿
    func showCannotOpenMailAppAlert() {
        let alert = UIAlertController(title: "✉️ [Mail] 앱을 열지 못했습니다.", message: "[Mail] 앱 연동 상태를 확인해주세요.\n다른 메일 사용 시 rei1998@naver.com로 메일 부탁드립니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirm)
        navigationController.present(alert, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    /// 메일 보내기 버튼 클릭 시 호출되는 델리게이트 메서드
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
