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
    func presentKakaoLoginSuccess(_ oauthToken: String)
    func presentKakaoLoginFailure(_ error: Error)
    func presentKakaoLogoutSuccess()
    
    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential)
    func presentAppleLoginFailure(_ error: Error)
    func presentAppleLogoutSuccess()
    func presentAppleLogoutFailure(_ error: Error)
    
    func presentUserCreated(_ response: Login.LoadLogin.Response)
    func presentUserCreationFailed(_ error: ApiError)
}

class LoginPresenter: LoginPresentationLogic {
    var view: LoginDisplayLogic?
    
    func presentKakaoLoginSuccess(_ oauthToken: String) {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao login successful", oauthToken: oauthToken)
        view?.display(viewModel: viewModel)
    }
    
    func presentKakaoLogoutSuccess() {
        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao logout successful", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    
    func presentKakaoLoginFailure(_ error: Error) {
        let viewModel = Login.LoadLogin.ViewModel(success: false, message: "Kakao login failed: \(error.localizedDescription)", oauthToken: "")
        view?.display(viewModel: viewModel)
    }
    
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
    
    func presentUserCreated(_ response: Login.LoadLogin.Response) {
        // 디폴트 값을 사용하여 accessToken이 nil일 때 빈 문자열로 대체
        let accessToken = response.tokens?.accessToken ?? ""
        let viewModel = Login.LoadLogin.ViewModel(
            success: response.success,
            message: response.message,
            oauthToken: accessToken
        )
        view?.display(viewModel: viewModel)
    }

    
    func presentUserCreationFailed(_ error: ApiError) {
        let viewModel = Login.LoadLogin.ViewModel(
            success: false,
            message: "User creation failed: \(error.localizedDescription)",
            oauthToken: ""
        )
        view?.display(viewModel: viewModel)
    }
}
