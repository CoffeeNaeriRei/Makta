//
//  SearchPathViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/16/24.
//

import Foundation
import SwiftUI
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
        super.viewDidLoad()
        setup()
        bind()
    }

    deinit {
        print("SearchPathViewController Deinit")
    }
    
    private func setup() {
        mainView.configure(.custom)
    }
    private func bind() {
        let output = vm.transform(input: MainViewModel.Input(settingButtonTap: nil, starButtonTap: nil))
        output.startLocation
            .drive(mainView.startLocationTextField.rx.text)
            .disposed(by: disposeBag)
        output.destinationLocation
            .drive(mainView.endLocationTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension SearchPathViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let detentIdentifier = sheetPresentationController.selectedDetentIdentifier {
            switch detentIdentifier {
            case UISheetPresentationController.Detent.Identifier(rawValue: "initDent"):
                mainView.configure(.custom)
            case .large:
                mainView.configure(.large)
            default:
                return
            }
        }
    }
}

extension SearchPathViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

#if DEBUG
struct SearchPathViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SearchPathViewController(
                vm: MainViewModel(
                    MakchaInfoUseCase(
                        TransPathRepository(APIService()),
                        EndPointRepository(LocationService())
                    )
                )
            )
        }
    }
}
#endif
