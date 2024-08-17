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
    
    private let isSheetOpened = BehaviorRelay(value: false)
    
    private let searchPathVM: SearchPathViewModel
    private let disposeBag = DisposeBag()
    
    weak var navigation: MainNavigation?

    init(_ searchPathViewModel: SearchPathViewModel) {
        self.searchPathVM = searchPathViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SearchPathViewController Deinit")
    }
    
    override func loadView() {
        view = SearchPathView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        mainView.startPointTextField.delegate = self
        mainView.destinationPointTextField.delegate = self
        mainView.searchResultTableView.delegate = self
        mainView.configure(.custom)
    }
    private func bind() {
        let startPointTextFieldChange = mainView.startPointTextField.rx.text.orEmpty
        let destinationPointTextFieldChange = mainView.destinationPointTextField.rx.text.orEmpty
        let searchedPointSelected = mainView.searchResultTableView.rx.itemSelected
        let startPointResetButtonTap = mainView.resetStartPointButton.rx.tap
        let destinationPointResetButtonTap = mainView.resetDestinationPointButton.rx.tap
        let searchButtonTap = mainView.searchButton.rx.tap
        let closeButtonTap = mainView.closeButton.rx.tap
        
        let output = searchPathVM.transform(
            input: SearchPathViewModel.Input(
                startPointTextFieldChange: startPointTextFieldChange,
                destinationPointTextFieldChange: destinationPointTextFieldChange,
                startPointTextFieldFocus: ( mainView.startPointTextField.rx.controlEvent(.editingDidBegin), mainView.startPointTextField),
                destinationPointTextFieldFocus: (mainView.destinationPointTextField.rx.controlEvent(.editingDidBegin), mainView.destinationPointTextField),
                searchedPointSelect: searchedPointSelected,
                startPointResetButtonTap: startPointResetButtonTap,
                destinationPointResetButtonTap: destinationPointResetButtonTap,
                searchButtonTap: searchButtonTap,
                isSheetOpened: isSheetOpened,
                closeButtonTap: closeButtonTap
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
        // 검색 버튼 클릭 시 이벤트
        output.searchButtonPressed
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                // 시트 내리기
                self.navigation?.pullDownSheet()
                self.updateToCustomSheet()
            })
            .disposed(by: disposeBag)
        
        // 시트 닫기 버튼 클릭 시 이벤트
        output.closeButtonPressed
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                view.endEditing(true)
                self.navigation?.pullDownSheet()
                self.updateToCustomSheet()
            })
            .disposed(by: disposeBag)
    }
}

extension SearchPathViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let detentIdentifier = sheetPresentationController.selectedDetentIdentifier {
            switch detentIdentifier {
            case UISheetPresentationController.Detent.Identifier(rawValue: "initDent"):
                updateToCustomSheet()
            case .large:
                updateToLargeSheet()
            default:
                return
            }
        }
    }
    
    /// Sheet의 detent가 .custom일 때의 업데이트 처리
    private func updateToCustomSheet() {
        mainView.configure(.custom)
        isSheetOpened.accept(false)
    }
    
    /// Sheet의 detent가 .large일 때의 업데이트 처리
    private func updateToLargeSheet() {
        mainView.configure(.large)
        isSheetOpened.accept(true)
    }
}

extension SearchPathViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isSheetOpened.value {
            self.navigation?.pullUpSheet()
            mainView.configure(.large)
        }
    }
}

extension SearchPathViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          view.endEditing(true)
      }
}

#if DEBUG
struct SearchPathViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            let apiService = APIService()
            let locationService = LocationService()
            let makchaInfoUseCase = MakchaInfoUseCase(
                TransPathRepository(apiService),
                EndPointRepository(locationService, apiService)
            )
            
            return SearchPathViewController(
                SearchPathViewModel(makchaInfoUseCase)
            )
        }
    }
}
#endif
