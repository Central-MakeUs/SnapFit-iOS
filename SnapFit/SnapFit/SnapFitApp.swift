//
//  SnapFitApp.swift
//  SnapFit
//
//  Created by 정정욱 on 7/9/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
@main
struct SnapFitApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    init() {
        // Kakao SDK 초기화 스유 버전
        //        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        //        
        //        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
