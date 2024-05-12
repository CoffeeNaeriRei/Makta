//
//  MainViewModel.swift
//  Makcha
//
//  Created by yuncoffee on 5/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let resetCoordinateAction: ControlEvent<Void>
        let worldButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let currentTime: Driver<String>
        let worldText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let currentTime = input.resetCoordinateAction
            .map { 
                print("변환")
                return Date().description
            }
            .asDriver(onErrorJustReturn: "")
        
        let worldText = input.worldButtonTap
            .map {"World"}
            .asDriver(onErrorJustReturn: "")
        
        return Output(currentTime: currentTime, worldText: worldText)
    }
}
