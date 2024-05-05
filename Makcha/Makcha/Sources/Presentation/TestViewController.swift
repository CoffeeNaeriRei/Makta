//
//  TestViewController.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

public final class TestViewController: UIViewController {
    
    let customView = TestView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func loadView() {
        view = customView
        
    }
}

#Preview {
    TestViewController()
}
