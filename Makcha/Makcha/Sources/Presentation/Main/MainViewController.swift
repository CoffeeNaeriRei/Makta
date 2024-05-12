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
    
    private let vm = MainViewModel()
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    public override func loadView() {
        view = MainView()
    }
    
    private func bind() {
        let input = MainViewModel.Input(resetCoordinateAction: mainView.button1.rx.tap)
        let output = vm.transform(input: input)
        
        output.currentTime
            .drive(mainView.currentTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
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
