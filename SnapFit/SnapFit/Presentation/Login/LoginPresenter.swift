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
    
//    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential)
//    func presentAppleLoginFailure(_ error: Error)
//    func presentAppleLogoutSuccess()
//    func presentAppleLogoutFailure(_ error: Error)
    

}

class LoginPresenter: LoginPresentationLogic {
   
    func presentLoginFailure(_ error: any Error) {
        print("presentLoginFailure \(error)")
    }
    
   
    
    
    var view: LoginDisplayLogic?
    
    func presentKakaoLoginSuccess(_ loginState: Bool) { // 참 값이 전달
        let viewModel = Login.LoadLogin.ViewModel(socialLoginType: "kakao", oauthToken: nil, userVerification: loginState)
        view?.display(viewModel: viewModel)
    }
 
    func presentKakaoLoginFailure(_ loginState: Bool, accessToken: String) {
        let viewModel = Login.LoadLogin.ViewModel(socialLoginType: "kakao", oauthToken: accessToken, userVerification: loginState)
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
    
}
