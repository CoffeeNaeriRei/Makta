//
//  SettingsViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
import MessageUI
import SwiftUI
import UIKit

import MakchaDesignSystem
import RxSwift

final class SettingsViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: SettingsView {
        view as! SettingsView
    }
    // swiftlint: enable force_cast
    
    let menus = Observable.of(["기본 도착지 수정하기", "위치 권한 허용하기", "개발자 문의"])
    private let disposeBag = DisposeBag()
    
    deinit {
        print("SettingsViewController Deinit")
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        view = SettingsView()
    }
    
    private func bind() {
        // 테이블뷰 바인딩
        mainView.settingsTableView.delegate = self
        menus.bind(to: mainView.settingsTableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0)) as UITableViewCell
            cell.textLabel?.text = item
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        .disposed(by: disposeBag)
        
        // 테이블 뷰 항목 선택
        mainView.settingsTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { `self`, indexPath in
                switch indexPath.row {
                case 0:
                    // TODO: - OnboardingViewController로 이동
                    print("OnboardingViewController로 이동")
                case 1:
                    self.showSettingsAppOpenAlert()
                case 2:
                    self.showEmailInquiryView()
                default:
                    break
                }
                self.mainView.settingsTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    /// 이메일 문의 화면 띄우기
    private func showEmailInquiryView() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setToRecipients(["rei1998@naver.com"])
            composeVC.setSubject("[막타] 앱 관련 문의 메일")
            composeVC.setMessageBody("문의하실 내용을 마음껏 작성해주세요 !\n피드백은 적극적으로 반영하겠습니다:)", isHTML: false)
            
            self.present(composeVC, animated: true)
        } else {
            // TODO: - 메일을 보낼 수 없습니다 에러 표시
        }
    }
    
    /// [설정] 앱 열기
    private func openSettingsApp() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// [설정] 앱 열기 안내 알럿
    private func showSettingsAppOpenAlert() {
        let alert = UIAlertController(title: "[⚙️설정] 앱으로 이동", message: "위치 권한의 수정은 [설정] 앱에서만 가능합니다.", preferredStyle: .alert)
        let move = UIAlertAction(title: "이동하기", style: .default) { _ in
            self.openSettingsApp()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(move)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    /// 메일 보내기 버튼 클릭 시 호출되는 델리게이트 메서드
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let apiService = APIService()
            let locationService = LocationService()
            let onbardingUseCase = OnboardingUseCase(
                TransPathRepository(apiService),
                EndPointRepository(locationService, apiService)
            )
            
            navigationController?.pushViewController(OnboardingViewController(OnboardingViewModel(onbardingUseCase), type: .enterToSettings), animated: true)
        }
    }
}

#if DEBUG
struct SettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            UINavigationController(rootViewController: SettingsViewController())
        }
    }
}
#endif
