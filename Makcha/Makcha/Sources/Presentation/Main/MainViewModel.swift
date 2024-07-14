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
    var startPointName = BehaviorRelay(value: "")
    var endPointName = BehaviorRelay(value: "")
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        // MainView 관련 인풋
        let viewDidLoadEvent = PublishRelay<Void>() // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
        let settingButtonTap: ControlEvent<Void>? // [설정] 버튼 탭
        let starButtonTap: ControlEvent<Void>? // [즐겨찾기] 버튼 탭
        
        // SearchPathView 관련 인풋
        let startPointTextFieldChange: ControlProperty<String>? // 출발지 텍스트필드 입력 변화 감지
        let destinationPointTextFieldChange: ControlProperty<String>? // 도착지 텍스트필드 입력 변화
        let searchedPointSelect: ControlEvent<IndexPath>? // 출발지/도착지 검색 결과 목록 중 하나를 선택
        let startPointResetButtonTap: ControlEvent<Void>? // 출발지 리셋버튼 탭
        let destinationPointResetButtonTap: ControlEvent<Void>? // 도착지 리셋버튼 탭
        let searchButtonTap: ControlEvent<Void>? // 검색 버튼 탭
    }
    
    struct Output {
        let startPointLabel: Driver<String> // 출발지
        let destinationPointLabel: Driver<String> // 도착지
        let startPointSearchedResult: Observable<[EndPoint]> // 출발지 검색 결과 리스트
        let destinationPointSearchedResult: Observable<[EndPoint]> // 도착지 검색 결과 리스트
    }
    
    func transform(input: Input) -> Output {
        // input
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vm, _ in
                vm.makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
            }
            .disposed(by: disposeBag)
        
        input.settingButtonTap?
            .withUnretained(self)
            .subscribe { vm, _ in
                print("뷰모델에서 세팅 버튼 클릭 이벤트 바인딩")
                // navigation으로 직접 호출
                vm.navigation?.goToSettings()
            }
            .disposed(by: disposeBag)
        
        input.starButtonTap?
            .withUnretained(self)
            .subscribe { vm, _ in
                print("뷰모델에서 스타 버튼 클릭 이벤트 바인딩")
                // 프로토콜을 통한 메서드로 호출
                vm.goToRemark()
            }
            .disposed(by: disposeBag)

        // MARK: makchaSectionModel 데이터 처리
        makchaInfoUseCase.makchaSectionModel
            .withUnretained(self)
            .subscribe(onNext: {
                $0.tempSections.accept([.init(model: $1.startTimeStr, items: $1.makchaCellData)])
            })
            .disposed(by: disposeBag)
        
        input.startPointTextFieldChange?
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: true, searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        input.destinationPointTextFieldChange?
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(isStartPoint: false, searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        input.searchedPointSelect?
            .withUnretained(self)
            .subscribe(onNext: { `self`, event in
                self.makchaInfoUseCase.updatePointToSearchedAddress(idx: event.row)
            })
            .disposed(by: disposeBag)
        
        input.startPointResetButtonTap?
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.resetStartPoint()
            })
            .disposed(by: disposeBag)
        
        input.destinationPointResetButtonTap?
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.resetDestinationPoint()
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTap?
            .withUnretained(self)
            .subscribe(onNext: { `self`, _ in
                self.makchaInfoUseCase.loadMakchaPathWithSearchedLocation()
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
        
        startLocation.asObservable()
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.startPointName.accept($0.1)
            })
            .disposed(by: disposeBag)
        
        destinationLocation.asObservable()
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.endPointName.accept($0.1)
            })
            .disposed(by: disposeBag)

        return Output(
            startPointLabel: startPointLabel,
            destinationPointLabel: destinationPointLabel,
            startPointSearchedResult: startPointSearchedResult,
            destinationPointSearchedResult: destinationPointSearchedResult
        )
    }
    
    // 현재 위치 재설정 버튼 클릭시 이벤트 처리를 위한 메서드
    func resetToCurrentLocationTap() {
        tempSections.accept([])
        makchaInfoUseCase.loadMakchaPathWithCurrentLocation()
    }
}

extension MainViewModel: MainCollectionViewDelegate {
    func goToDetails(_ indexPath: IndexPath) {
        let (sectionIndex, modelIndex) = (indexPath.section, indexPath.row)
        let cellData = tempSections.value[sectionIndex].items[modelIndex]
        
        goToDetails(with: cellData, path: (startPointName.value, endPointName.value))
    }
}

// MARK: 델리게이션을 통한 코디네이터 처리
extension MainViewModel: MainNavigation {
    func goToSettings() {
        print("뷰모델에서 세팅 버튼 클릭 호출")
        navigation?.goToSettings()
    }
    
    func goToRemark() {
        print("뷰모델에서 스타 버튼 클릭 호출")
        navigation?.goToRemark()
    }
    
    func showSheet(_ height: CGFloat, with vm: MainViewModel) {
        navigation?.showSheet(height, with: vm)
    }
    
    func goToDetails(with data: MakchaCellData, path: (String, String)) {
        navigation?.goToDetails(with: data, path: path)
    }
}
