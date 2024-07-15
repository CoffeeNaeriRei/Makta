//
//  DetailViewController.swift
//  Makcha
//
//  Created by yuncoffee on 6/2/24.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {
    // swiftlint: disable force_cast
    private var mainView: DetailView {
        view as! DetailView
    }
    // swiftlint: enable force_cast
    
    private let rightUIBarButtonItem = UIBarButtonItem()
    
    private let data: MakchaCellData
    private var path: (String, String)
    
    init(data: MakchaCellData, path: (String, String)) {
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
        #if DEBUG
        print(data.arrival.first.arrivalMessage)
        print(data.arrival.second.arrivalMessage)
        #endif
    }
    
    override func loadView() {
        view = DetailView()
    }
    
    private func setup() {
        mainView.configure(data: data, path: path)
        setupNavigationItems()
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
