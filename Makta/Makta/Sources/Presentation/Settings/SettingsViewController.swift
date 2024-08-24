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
    
    let menus = Observable.of(["기본 도착지 수정하기", "위치 권한 허용하기", "개발자 문의", "앱 버전"])
    private let disposeBag = DisposeBag()
    
    weak var navigation: SettingsNavigation?
    
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
        menus.bind(to: mainView.settingsTableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0)) as UITableViewCell
            cell.textLabel?.text = item
            if row == 3 {
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
                let label = UILabelFactory.build(text: "\(appVersion)", textColor: .cf(.grayScale(.gray600)))
                label.sizeToFit()
                
                cell.accessoryView = label
                
            } else {
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
        }
        .disposed(by: disposeBag)
        
        // 테이블 뷰 항목 선택
        mainView.settingsTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { `self`, indexPath in
                switch indexPath.row {
                case 0:
                    self.navigation?.goToDestinationEdit()
                case 1:
                    self.navigation?.showSettingsAppOpenAlert()
                case 2:
                    self.navigation?.showMailInquirySheet()
                default:
                    break
                }
                self.mainView.settingsTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
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
