//
//  Preview+Extension.swift
//  Makcha
//
//  Created by yuncoffee on 5/6/24.
//

#if DEBUG
import SwiftUI

struct ViewPreview: UIViewRepresentable {
    
    var viewBuilder: () -> UIView
    
    init(_ viewControllerBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewControllerBuilder
    }
    
    func makeUIView(context: Context) -> some UIView {
        viewBuilder()
    }
    
    func updateUIView(_ uiViewController: UIViewType, context: Context) {
        // Nothing to do here
    }
}

struct ViewControllerPreview: UIViewControllerRepresentable {
    
    var viewControllerBuilder: () -> UIViewController
    
    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        viewControllerBuilder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Nothing to do here
    }
}
#endif
