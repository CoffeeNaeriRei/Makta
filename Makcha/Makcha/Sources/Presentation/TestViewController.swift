//
//  TestViewController.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import RxSwift

public final class TestViewController: UIViewController {
    
    public let testView = TestView()
    
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoaded")
    }
    
    // 뷰 컨트롤러가 자신의 뷰를 생성할 때 호출하는 메서드
    public override func loadView() {
        view = testView
    }
}

#Preview {
    TestViewController()
}
