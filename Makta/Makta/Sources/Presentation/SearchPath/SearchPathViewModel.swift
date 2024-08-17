//
//  SearchPathViewModel.swift
//  Makcha
//
//  Created by 김영빈 on 7/4/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class SearchPathViewModel: ViewModelType {
    private let makchaInfoUseCase: MakchaInfoUseCase
    private let disposeBag = DisposeBag()
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let startPointTextFieldChange: ControlProperty<String> // 출발지 텍스트필드 입력 변화 감지
        let destinationPointTextFieldChange: ControlProperty<String> // 도착지 텍스트필드 입력 변화
        let startPointTextFieldFocus: (ControlEvent<()>, UITextField)
        let destinationPointTextFieldFocus: (ControlEvent<()>, UITextField)
        let searchedPointSelect: ControlEvent<IndexPath> // 출발지/도착지 검색 결과 목록 중 하나를 선택
        let startPointResetButtonTap: ControlEvent<Void> // 출발지 리셋버튼 탭
        let destinationPointResetButtonTap: ControlEvent<Void> // 도착지 리셋버튼 탭
        let searchButtonTap: ControlEvent<Void> // 검색 버튼 탭
        let isSheetOpened: BehaviorRelay<Bool> // 검색 시트가 열려있는 상태인지
        let closeButtonTap: ControlEvent<Void> // 닫기 버튼 클릭
    }
    
    struct Output {
        let startPointLabel: Driver<String> // 출발지
        let destinationPointLabel: Driver<String> // 도착지
        let startPointSearchedResult: Observable<[EndPoint]> // 출발지 검색 결과 리스트
        let destinationPointSearchedResult: Observable<[EndPoint]> // 도착지 검색 결과 리스트
        let searchButtonPressed: Driver<Void> // 막차 경로 검색 버튼이 눌림
        let closeButtonPressed: Driver<Void> // 닫기 버튼이 눌림
    }
    
    func transform(input: Input) -> Output {
        // input
        input.startPointTextFieldChange
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: true, searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        input.destinationPointTextFieldChange
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: false, searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        input.startPointTextFieldFocus
            .0.withUnretained(self)
            .subscribe { `self`, _ in
                if let text = input.startPointTextFieldFocus.1.text, text != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: true, searchKeyword: text)
                }
            }
            .disposed(by: disposeBag)
       
        input.destinationPointTextFieldFocus
            .0.withUnretained(self)
            .subscribe { `self`, _ in
                if let text = input.destinationPointTextFieldFocus.1.text, text != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: false, searchKeyword: text)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchedPointSelect
            .withUnretained(self)
            .subscribe(onNext: { `self`, event in
                self.makchaInfoUseCase.updatePointToSearchedAddress(idx: event.row)
            })
            .disposed(by: disposeBag)
        
        input.startPointResetButtonTap
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.resetStartPoint()
            })
            .disposed(by: disposeBag)
        
        input.destinationPointResetButtonTap
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.resetDestinationPoint()
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.loadMakchaPathWithSearchedLocation()
            })
            .disposed(by: disposeBag)
        
        input.isSheetOpened
            .withUnretained(self)
            .subscribe(onNext: { `self`, isOpened in
                self.makchaInfoUseCase.updateIsSheetOpened(isOpened)
            })
            .disposed(by: disposeBag)
        
        // output
        let startPointLabel = makchaInfoUseCase.startPoint
            .map { $0.name ?? $0.roadAddressName ?? $0.addressName }
            .asDriver(onErrorJustReturn: "")
        
        let destinationPointLabel = makchaInfoUseCase.destinationPoint
            .map { $0.name ?? $0.roadAddressName ?? $0.addressName }
            .asDriver(onErrorJustReturn: "")
        
        let startPointSearchedResult = makchaInfoUseCase.searchedStartPoints
        let destinationPointSearchedResult = makchaInfoUseCase.searchedDestinationPoints
        let searchButtonPressed = input.searchButtonTap.asDriver()
        let closeButtonPressed = input.closeButtonTap.asDriver()
        
        return Output(
            startPointLabel: startPointLabel,
            destinationPointLabel: destinationPointLabel,
            startPointSearchedResult: startPointSearchedResult,
            destinationPointSearchedResult: destinationPointSearchedResult,
            searchButtonPressed: searchButtonPressed,
            closeButtonPressed: closeButtonPressed
        )
    }
}
