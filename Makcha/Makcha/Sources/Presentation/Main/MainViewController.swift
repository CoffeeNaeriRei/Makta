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
    var mainView: MainView {
        view as! MainView
    }
    // swiftlint: enable force_cast
    
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    public override func loadView() {
        view = MainView()
    }
    
    private func bind() {
        mainView.button1.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.buttonAction()
            }
            .disposed(by: disposeBag)
    }
    
    private func buttonAction() {
        print("HELLO WORLD!")
    }
}

#if DEBUG
import SwiftUI
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            MainViewController()
        }
    }
}
#endif
