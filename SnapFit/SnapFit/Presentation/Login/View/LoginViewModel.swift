//
//  kakaoAuthViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/11/24.
//


import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

class LoginViewModel: NSObject, ObservableObject {
    @Published var isKakaoLogin = false
    @Published var isAppleLoggedIn = false
    @Published var shouldNavigate: Bool = false
    @Published var appleUserIdentifier: String? = nil
    @Published var loginMessage: String = ""
    
    @Published var social: String = ""
    @Published var nickName: String = ""
    @Published var isMarketing: Bool = false

}
