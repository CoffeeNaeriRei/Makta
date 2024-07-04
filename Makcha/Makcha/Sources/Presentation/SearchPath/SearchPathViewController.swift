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
    
    private let vm: SearchPathViewModel
    private let disposeBag = DisposeBag()

    init(_ searchPathViewModel: SearchPathViewModel) {
        self.vm = searchPathViewModel
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
        let startPointTextFieldChange = mainView.startPointTextField.rx.text.orEmpty
        let destinationPointTextFieldChange = mainView.destinationPointTextField.rx.text.orEmpty
        let searchedPointSelected = mainView.searchResultTableView.rx.itemSelected
        let startPointResetButtonTap = mainView.resetStartPointButton.rx.tap
        let destinationPointResetButtonTap = mainView.resetDestinationPointButton.rx.tap
        let searchButtonTap = mainView.searchButton.rx.tap
        
        let output = vm.transform(
            input: SearchPathViewModel.Input(
                startPointTextFieldChange: startPointTextFieldChange,
                destinationPointTextFieldChange: destinationPointTextFieldChange,
                searchedPointSelect: searchedPointSelected,
                startPointResetButtonTap: startPointResetButtonTap,
                destinationPointResetButtonTap: destinationPointResetButtonTap,
                searchButtonTap: searchButtonTap
            )
        )
        // 출발지 검색 텍스트필드
        output.startPointLabel
            .drive(mainView.startPointTextField.rx.text)
            .disposed(by: disposeBag)
        // 도착지 검색 텍스트필드
        output.destinationPointLabel
            .drive(mainView.destinationPointTextField.rx.text)
            .disposed(by: disposeBag)
        // 검색 결과 바인딩
        /// merge()를 사용하여 파라미터 항목들이 각각 이벤트를 방출할 때마다 가장 최근 것으로 방출
        Observable.merge(output.startPointSearchedResult, output.destinationPointSearchedResult)
            .bind(to: mainView.searchResultTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0)) as SearchResultCell
                cell.configure(with: item)
                return cell
            }
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
            let apiService = APIService()
            let locationService = LocationService()
            
            return SearchPathViewController(
                SearchPathViewModel(
                    MakchaInfoUseCase(
                        TransPathRepository(apiService),
                        EndPointRepository(locationService, apiService)
                    )
                )
            )
        }
    }
}
#endif
