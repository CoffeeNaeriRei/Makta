//
//  SettingsViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/19/24.
//

import Foundation
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
