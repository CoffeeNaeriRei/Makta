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
    var isAppStarted: Bool = false // foreground 진입 시 최초 실행 여부를 판단하기 위한 플래그

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    /**
     scene이 foreground로 진입할 때 호출되는 메서드 (≈ 앱이 foreground로 진입할 때라고 봐도 됨)
     - 앱을 시작한 뒤에 background → foreground 진입을 하게 되면 막차 경로를 다시 불러온다.
        - 앱을 시작하면서 foreground로 진입하는 경우는 제외
     */
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("\n⚪️⚪️포어그라운드 진입⚪️⚪️\n")
        if isAppStarted {
            coordinator?.makchaInfoUseCase.loadMakchaPathWithSearchedLocation()
        } else {
            isAppStarted = true
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
