//
//  DetailViewController.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {
    
    let data: MakchaCellData
    
    init(data: MakchaCellData) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        print(data.arrival.first.arrivalMessage)
        print(data.arrival.second.arrivalMessage)
    }
}
