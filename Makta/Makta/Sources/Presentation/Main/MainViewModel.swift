//
//  MainViewModel.swift
//  Makcha
//
//  Created by yuncoffee on 5/12/24.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

// MARK: - 메인 화면의 뷰모델 (막차 경로 불러오는 화면)
final class MainViewModel: ViewModelType {
    private let makchaInfoUseCase: MakchaInfoUseCase
    private let disposeBag = DisposeBag()
    
    weak var navigation: MainNavigation?
    
    // 임시로 MainCollectionView의 DataSource를 채우기 위한 프로퍼티
    // 추후 명칭 변경 필요.
    var tempSections = BehaviorRelay(value: [SectionOfMainCard]())
    // MARK: 다른 VC에 전달하기 위한 값
    var startPointName = ""
    var destinationPointName = ""
    
    private var isFirstAppear = true
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let viewDidLoadedEvent = PublishRelay<Void>()
        let viewDidAppearEvent: Observable<Void>
        let settingButtonTap: ControlEvent<Void> // [설정] 버튼 탭
//        let starButtonTap: ControlEvent<Void> // [즐겨찾기] 버튼 탭
        let loadButtonTap: ControlEvent<Void> // 막차 경로 더 불러오기
        let reloadButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let makchaErrorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        // input
        input.viewDidLoadedEvent
            .withUnretained(self)
            .subscribe { vm, _ in
                vm.makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
            }
            .disposed(by: disposeBag)
        
        input.viewDidAppearEvent
            .withUnretained(self)
            .subscribe { vm, _ in
                // 화면 전환 시 막차 정보를 새로 불러옴(갱신)
                if !vm.isFirstAppear {
                    vm.makchaInfoUseCase.loadMakchaPathWithSearchedLocation()
                }
                vm.isFirstAppear = false
            }
            .disposed(by: disposeBag)
        
        input.settingButtonTap
            .withUnretained(self)
            .subscribe { vm, _ in
                // navigation으로 직접 호출
                vm.navigation?.goToSettings()
            }
            .disposed(by: disposeBag)
        
//        input.starButtonTap
//            .withUnretained(self)
//            .subscribe { vm, _ in
//                // 프로토콜을 통한 메서드로 호출
//                vm.goToRemark()
//            }
//            .disposed(by: disposeBag)
        
        input.loadButtonTap
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.updateMakchaPathNumToLoad()
            })
            .disposed(by: disposeBag)

        input.reloadButtonTap
            .withUnretained(self)
            .subscribe { `self`, _ in
                self.makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
            }
            .disposed(by: disposeBag)
        
        // MARK: makchaSectionModel 데이터 처리
        makchaInfoUseCase.makchaSectionOfMainCard
            .withUnretained(self)
            .subscribe(onNext: {
                // 데이터를 받기 전에 한번 확인하자.
                if self.makchaInfoUseCase.ifNeedLoadMakchaPath() {
                    $0.tempSections.accept([.init(model: $1.model, items: $1.items), .init(model: "more", items: [])])
                } else {
                    $0.tempSections.accept([.init(model: $1.model, items: $1.items)])
                }
            })
            .disposed(by: disposeBag)
        
        makchaInfoUseCase.startPoint.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { `self`, startPoint in
                self.startPointName = startPoint.name ?? startPoint.roadAddressName ?? startPoint.addressName
            })
            .disposed(by: disposeBag)
        
        makchaInfoUseCase.destinationPoint.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { `self`, destinationPoint in
                self.destinationPointName = destinationPoint.name ?? destinationPoint.roadAddressName ?? destinationPoint.addressName
            })
            .disposed(by: disposeBag)

        let makchaErrorMessage = makchaInfoUseCase.makchaErrorMessage.asDriver(onErrorJustReturn: "")
        
        return Output(makchaErrorMessage: makchaErrorMessage)
    }
    
    // 현재 위치 재설정 버튼 클릭시 이벤트 처리를 위한 메서드
    func resetToCurrentLocationTap() {
        tempSections.accept([])
        makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
    }
    
    func loadMorePath() {
        makchaInfoUseCase.updateMakchaPathNumToLoad()
    }
}

extension MainViewModel: MainCollectionViewDelegate {
    func goToDetails(_ indexPath: IndexPath) {
        let (sectionIndex, modelIndex) = (indexPath.section, indexPath.row)
        let cellData = tempSections.value[sectionIndex].items[modelIndex]
        
        goToDetails(modelIndex, with: cellData, path: (startPointName, destinationPointName))
    }
}

// MARK: 델리게이션을 통한 코디네이터 처리
extension MainViewModel: MainNavigation {
    func goToSettings() {
        navigation?.goToSettings()
    }
    
    func goToRemark() {
        navigation?.goToRemark()
    }
    
    func showSheet(_ height: CGFloat) {
        navigation?.showSheet(height)
    }
    
    func pullUpSheet() {}
    
    func pullDownSheet() {}
    
    func goToDetails(_ makchaIdx: Int, with data: MakchaCellData, path: (String, String)) {
        navigation?.goToDetails(makchaIdx, with: data, path: path)
    }
    
    func showTransPathErrorAlert(with message: String) {
        navigation?.showTransPathErrorAlert(with: message)
    }
}
