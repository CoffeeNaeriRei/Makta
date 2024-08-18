//
//  SplashVC.swift
//  Makta
//
//  Created by yuncoffee on 8/18/24.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: SplashView {
        view as! SplashView
    }
    // swiftlint: enable force_cast
    
    weak var navigation: AppNavigation?
    
    init(_ navigation: AppNavigation?) {
        self.navigation = navigation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SplashView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigation?.goToStart()
       }
    }
}
