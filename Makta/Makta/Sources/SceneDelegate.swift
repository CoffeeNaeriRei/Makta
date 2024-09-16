//
//  SceneDelegate.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    private var isAppStarted: Bool = false // foreground 진입 시 최초 실행 여부를 판단하기 위한 플래그

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let appperance = UINavigationBar.appearance()
        
        appperance.shadowImage = UIImage()
        appperance.setBackgroundImage(UIImage(), for: .default)
        appperance.tintColor = .cf(.grayScale(.gray700))
        appperance.titleTextAttributes = [
            .foregroundColor: UIColor.cf(.grayScale(.gray900)),
            .font: UIFont.pretendard(.medium, size: 16)
        ]

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let vc = UINavigationController()
        coordinator = AppCoordinator(vc)
        coordinator?.start()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    /**
     scene이 foreground로 진입할 때 호출되는 메서드 (≈ 앱이 foreground로 진입할 때라고 봐도 됨)
     - 앱을 시작한 뒤에 background → foreground 진입을 하게 되면 막차 경로를 다시 불러온다.
        - 앱을 시작하면서 foreground로 진입하는 경우는 제외
     */
    func sceneWillEnterForeground(_ scene: UIScene) {
        if isAppStarted {
            coordinator?.makchaInfoUseCase.loadMakchaPathWithSearchedLocation()
        } else {
            isAppStarted = true
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
