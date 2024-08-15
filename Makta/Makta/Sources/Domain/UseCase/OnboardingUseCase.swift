//
//  OnboardingUseCase.swift
//  Makcha
//
//  Created by yuncoffee on 7/22/24.
//

// swiftlint: disable comment_spacing

//import Foundation
//
//import RxSwift
//
//final class OnboardingUseCase {
//    private let transPathRepository: TransPathRepositoryProtocol
//    private let endPointRepository: EndPointRepositoryProtocol
//    
//    let startPoint = PublishSubject<EndPoint>()
//    let destinationPoint = PublishSubject<EndPoint>()
//    let _destinationPoint: EndPoint = .mockDestinationPoint
//    let searchedDestinationPoints = BehaviorSubject<[EndPoint]>(value: [])
//    
//    private let disposeBag = DisposeBag()
//    private var destinationPointValue = EndPoint.mockDestinationPoint
//    
//    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
//        self.transPathRepository = transPathRepository
//        self.endPointRepository = endPointRepository
//    }
//}
//
//extension OnboardingUseCase {
//    func searchWithAddressText(searchKeyword: String) {
//        endPointRepository.getSearchedAddresses(searchKeyword: searchKeyword)
//            .withUnretained(self)
//            .subscribe { useCase, searched in
//                useCase.searchedDestinationPoints.onNext(searched)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    func updatePointToSearchedAddress(idx: Int) {
//        guard let selectedEndPoint = try? searchedDestinationPoints.value()[idx] else { return }
//        destinationPointValue = selectedEndPoint
//        destinationPoint.onNext(destinationPointValue)
//        selectedEndPoint.saveAsUserDefaults(key: .tempDestination)
//    }
//    
//    func saveDefaultDestinationPoint() {
//        let temp = EndPoint.loadFromUserDefaults(key: .tempDestination)
//        if let temp = temp {
//            temp.saveAsUserDefaults(key: .defaultDestination)
//            print("저장 ㅇㅇ")
//        }
//    }
//}

// swiftlint: enable comment_spacing
