//
//  MainViewController.swift
//  Makcha
//
//  Created by yuncoffee on 5/11/24.
//

import Foundation
import UIKit
import RxSwift

final class MainViewController: UIViewController {
    public let testView = TestView()
    
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoaded")
    }

    public override func loadView() {
        view = testView
    }
}

#if DEBUG
import SwiftUI
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            MainViewController()
        }
    }
}
#endif
