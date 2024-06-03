//
//  SearchPathViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/16/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class SearchPathViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: SearchPathView {
        view as! SearchPathView
    }
    // swiftlint: enable force_cast
    
    private let vm: MainViewModel
    private let disposeBag = DisposeBag()
    
    init(vm: MainViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SearchPathView()
    }
    
    override func viewDidLoad() {
        let output = vm.transform(input: MainViewModel.Input(settingButtonTap: nil, starButtonTap: nil))
        
        output.startLocation
            .drive(mainView.startLocationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("SearchPathViewController Deinit")
    }
}
