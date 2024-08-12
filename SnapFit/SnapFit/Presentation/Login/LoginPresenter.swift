//
//  LoginPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

// 뷰에게 전달할 Presenter 기능들을 정의
protocol LoginPresentationLogic {
    func presentKakaoLoginSuccess(_ loginState: Bool)
    func presentKakaoLoginFailure(_ loginState: Bool, accessToken: String)
    func presentKakaoLogoutSuccess()
    func presentLoginFailure(_ error: Error)
    func presentAlreadyregisteredusers(_ kakaoAccessToken: String  ,_ error: any Error)
    
    func presentVibes(_ vibes: [Vibe])
    func presentVibesFetchFailure(_ error: Error)
}

class LoginPresenter: LoginPresentationLogic {
   
    func presentLoginFailure(_ error: any Error) {
        print("presentLoginFailure \(error)")
     
    }
    
    func presentAlreadyregisteredusers(_ kakaoAccessToken: String  ,_ error: any Error) {
        let viewModel = Login.LoadLogin.LoginPresentationViewModel(socialLoginType: "kakao", oauthToken: nil, kakaoAccessToken: kakaoAccessToken, membershipRequired: true)
        view?.display(viewModel: viewModel)
    }
    
    
    var view: LoginDisplayLogic?
    
    func presentKakaoLoginSuccess(_ loginState: Bool) { // 참 값이 전달
        let viewModel = Login.LoadLogin.LoginPresentationViewModel(socialLoginType: "kakao", oauthToken: nil, kakaoAccessToken: nil, membershipRequired:false)
        view?.display(viewModel: viewModel)
    }
 
    func presentKakaoLoginFailure(_ loginState: Bool, accessToken: String) {
        let viewModel = Login.LoadLogin.LoginPresentationViewModel(socialLoginType: "kakao", oauthToken: accessToken, kakaoAccessToken: nil, membershipRequired: false)
        view?.display(viewModel: viewModel)
    }
    
    func presentKakaoLogoutSuccess() {
//        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao logout successful", oauthToken: "")
//        view?.display(viewModel: viewModel)
    }
    

  /*
    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential) {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Apple login successful", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLoginFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Apple login failed: \(error.localizedDescription)", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLogoutSuccess() {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Apple logout successful", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLogoutFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Apple logout failed: \(error.localizedDescription)", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    */
    
    func presentVibes(_ vibes: [Vibe]) {
        let viewModel = Login.LoadLogin.VibesPresentationViewModel(vibes: vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    func presentVibesFetchFailure(_ error: Error) {
        // 오류 처리 로직을 추가할 수 있습니다.
        print("Error fetching vibes: \(error)")
    }
}
