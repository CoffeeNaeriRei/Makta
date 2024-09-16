//
//  DetailViewController.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: DetailView {
        view as! DetailView
    }
    // swiftlint: enable force_cast
    
    private let rightUIBarButtonItem = UIBarButtonItem()
    
    private let idx: Int // 막차 정보 인덱스
    private let data: MakchaCellData
    private var path: (String, String)
    // TODO: - data, path 정보도 바인딩으로 처리하기
//    private let makchaCellData = PublishRelay<MakchaCellData>()
//    private let makchaEndPoints = PublishRelay<(String, String)>()
    
    private let makchaPath = PublishRelay<MakchaPath>()
    private let realtimeArrival = PublishRelay<RealtimeArrivalTuple>()
    
    private let firstArrivalMessage = PublishRelay<String>()
    private let secondArrivalMessage = PublishRelay<String>()
    
    weak var makchaInfoUseCase: MakchaInfoUseCase?
    private let disposeBag = DisposeBag()
    
    init(makchaIdx: Int, data: MakchaCellData, path: (String, String)) {
        self.idx = makchaIdx
        self.data = data
        self.path = path
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    override func loadView() {
        view = DetailView()
    }
    
    private func setup() {
        mainView.configure(data: data, path: path)
//        TODO: 새로고침 기능 구현
//        setupNavigationItems()
    }
    
    private func bind() {
        makchaInfoUseCase?.makchaSectionOfMainCard
            .withUnretained(self)
            .subscribe(onNext: { `self`, sectionOfMainCard in
//                self.makchaCellData.accept(sectionOfMainCard.items[self.idx])
                self.makchaPath.accept(sectionOfMainCard.items[self.idx].makchaPath)
                self.realtimeArrival.accept(sectionOfMainCard.items[self.idx].arrival)
            })
            .disposed(by: disposeBag)
        
        realtimeArrival
            .map { $0.first.status.arrivalMessageFirst }
            .bind(to: firstArrivalMessage)
            .disposed(by: disposeBag)
        
        realtimeArrival
            .map { $0.second.status.arrivalMessageFirst }
            .bind(to: secondArrivalMessage)
            .disposed(by: disposeBag)
        
        firstArrivalMessage.asDriver(onErrorJustReturn: "도착 정보 없음")
            .drive(mainView.currentArrivalTransportTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        secondArrivalMessage.asDriver(onErrorJustReturn: "다음 도착 정보 없음")
            .drive(mainView.nextArrivalTransportTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    private func setupNavigationItems() {
        let title = "경로 상세정보"
        
        rightUIBarButtonItem.title = "새로고침"
        rightUIBarButtonItem.image = .init(systemName: "gobackward")
        
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightUIBarButtonItem
    }
}
