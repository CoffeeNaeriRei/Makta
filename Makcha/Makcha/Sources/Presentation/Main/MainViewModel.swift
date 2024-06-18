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
    
    init(_ makchaInfoUseCase: MakchaInfoUseCase) {
        self.makchaInfoUseCase = makchaInfoUseCase
    }
    
    struct Input {
        let viewDidLoadEvent = PublishRelay<Void>() // 화면 최초 로딩 이벤트 (현재 위치 기반 경로 불러오기)
        let settingButtonTap: ControlEvent<Void>? // [설정] 버튼 탭
        let starButtonTap: ControlEvent<Void>? // [즐겨찾기] 버튼 탭
        
        let startPointTextFieldChanged: ControlProperty<String>? // 출발지 텍스트필드 입력 변화 감지
        let destinationPointTextFieldChanged: ControlProperty<String>? // 도착지 텍스트필드 입력 변화
//        let startPointResetButtonTap = PublishRelay<Void>() // 출발지 리셋버튼 탭
//        let destinationPointResetButtonTap = PublishRelay<Void>() // 도착지 리셋버튼 탭
//        let startPointSelected = PublishRelay<Int>() // 출발지 검색 결과에서 출발지 선택
//        let destinationPointSelected = PublishRelay<Int>() // 도착지 검색 결과에서 도착지 선택
//        let searchButtonTap = PublishRelay<Void>() // 검색 버튼 탭
    }
    
    struct Output {
        let startPointLabel: Driver<String> // 출발지
        let destinationPointLabel: Driver<String> // 도착지
        let pointSearchResult: Observable<[EndPoint]> // 장소 검색 결과 리스트
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
        
        input.startPointTextFieldChanged?
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        input.destinationPointTextFieldChanged?
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { `self`, inputText in
                if inputText != "" {
                    self.makchaInfoUseCase.searchWithAddressText(searchKeyword: inputText)
                }
            })
            .disposed(by: disposeBag)
        
        // output
        let startPointLabel = makchaInfoUseCase.startPoint
            .map { $0.name ?? $0.roadAddressName ?? $0.addressName }
            .asDriver(onErrorJustReturn: "")
        
        let destinationPointLabel = makchaInfoUseCase.destinationPoint
            .map { $0.name ?? $0.roadAddressName ?? $0.addressName }
            .asDriver(onErrorJustReturn: "")
        
        let pointSearchResult = makchaInfoUseCase.searchedEndPoints
        
        return Output(
            startPointLabel: startPointLabel,
            destinationPointLabel: destinationPointLabel,
            pointSearchResult: pointSearchResult
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
        
        goToDetails(with: cellData)
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
    
    func goToDetails(with data: MakchaCellData) {
        navigation?.goToDetails(with: data)
    }
}
