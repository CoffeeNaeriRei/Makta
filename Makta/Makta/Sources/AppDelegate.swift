//
//  AppDelegate.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import UIKit
import MakchaDesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let pretendard: () = { CoffeeFactoryFont.registerFonts() }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
