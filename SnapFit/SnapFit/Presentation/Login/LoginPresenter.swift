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
    func presentKakaoLoginSuccess(_ oauthToken: OAuthToken?)
    func presentKakaoLoginFailure(_ error: Error)
    func presentKakaoLogoutSuccess()
    
    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential)
    func presentAppleLoginFailure(_ error: Error)
    func presentAppleLogoutSuccess()
    func presentAppleLogoutFailure(_ error: Error)
}

class LoginPresenter: LoginPresentationLogic {
    var view: LoginDisplayLogic?
    
    func presentKakaoLoginSuccess(_ oauthToken: OAuthToken?) {
        // 뷰모델에게 값을 전달 하여 뷰를 업데이트
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao login successful")
        view?.display(viewModel: viewModel)
    }
    
    func presentKakaoLogoutSuccess() {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao logout successful")
        view?.display(viewModel: viewModel)
    }
    
    func presentKakaoLoginFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Kakao login failed: \(error.localizedDescription)")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential) {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Apple login successful")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLoginFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Apple login failed: \(error.localizedDescription)")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLogoutSuccess() {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Apple logout successful")
        view?.display(viewModel: viewModel)
    }
    
    func presentAppleLogoutFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Apple logout failed: \(error.localizedDescription)")
        view?.display(viewModel: viewModel)
    }
}
