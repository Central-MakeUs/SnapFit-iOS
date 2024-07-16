//
//  AppDelegate.swift
//  SnapFit
//
//  Created by 정정욱 on 7/11/24.
//

import SwiftUI
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        print("kakaoAppKey : \(kakaoAppKey)")
        return true
    }
    
    // 카카오 로그인 처리
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         if (AuthApi.isKakaoTalkLoginUrl(url)) {
             return AuthController.handleOpenUrl(url: url)
         }

         return false
     }
    
    // 해당 신델리게이트 사용한다고 설정해줘야함
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(name: nil , sessionRole: connectingSceneSession.role)
        
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}
