//
//  SceneDelegate.swift
//  SnapFit
//
//  Created by 정정욱 on 7/11/24.
//

import Foundation
import KakaoSDKAuth
import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
