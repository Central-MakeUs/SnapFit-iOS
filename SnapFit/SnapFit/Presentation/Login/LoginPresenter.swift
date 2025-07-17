//
//  LoginPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
// LoginPresenter.swift
// SnapFit
// Created by 정정욱 on 7/14/24.

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

// Presenter가 View에 전달해야 할 정보를 정의하는 프로토콜
protocol LoginPresentationLogic {
    func presentSocialLoginSuccess(socialLoginType: String, accessToken: String, oauthToken: String?)
    func presentKakaoLoginFailure(_ loginState: Bool, accessToken: String)
    func presentSocialLoginFailure(_ error: Error, socialLoginType: String, accessToken: String)
    func presentAlreadyregisteredusers(socialLoginType: String, oauthToken: String?, error: Error?)
    
    func presentSocialregisterSuccess(socialLoginType: String, accessToken: String, oauthToken: String?)
    func presentSocialregisterFailure(_ error: Error, socialLoginType: String, accessToken: String, oauthToken: String?)
    
    func presentVibes(_ vibes: [Vibe])
    func presentVibesFetchFailure(_ error: Error)
}

// Presenter는 Interactor로부터 받은 정보를 View에 전달하는 역할을 합니다.
class LoginPresenter: LoginPresentationLogic {
  
    
    
    var view: LoginDisplayLogic?  // View와의 통신을 위한 참조
    
  
    
    // 이미 등록된 사용자를 View에 전달
    func presentAlreadyregisteredusers(socialLoginType: String, oauthToken: String?, error: Error?) {
        // ViewModel을 생성하여 View에 전달
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: socialLoginType,
            oauthToken: oauthToken,
            socialAccessToken: nil,
            membershipRequired: false
        )
        view?.display(viewModel: viewModel)
    }
    
    
    // 소셜 로그인 성공
    func presentSocialLoginSuccess(socialLoginType: String, accessToken: String, oauthToken: String?) {
        // ViewModel을 생성하여 View에 전달
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: socialLoginType,
            oauthToken: oauthToken,
            socialAccessToken: accessToken,
            membershipRequired: false
        )
        view?.display(viewModel: viewModel)
    }
    
    // 로그인 실패를 View에 전달
    func presentSocialLoginFailure(_ error: Error, socialLoginType: String, accessToken: String) {
        
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: socialLoginType,
            oauthToken: "",
            socialAccessToken: accessToken,
            membershipRequired: true
        )
        view?.display(viewModel: viewModel)
    }
    
    // 소셜 회원가입 성공을 View에 전달
    func presentSocialregisterSuccess(socialLoginType: String, accessToken: String, oauthToken: String?) {
        // ViewModel을 생성하여 View에 전달
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: socialLoginType,
            oauthToken: oauthToken,
            socialAccessToken: accessToken,
            membershipRequired: false
        )
        view?.display(viewModel: viewModel)
    }
    
    // 소셜 회원가입 실패을 View에 전달
    func presentSocialregisterFailure(_ error: Error, socialLoginType: String, accessToken: String, oauthToken: String?) {
        print("회원가입 실패 \(error)")
        // ViewModel을 생성하여 View에 전달
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: socialLoginType,
            oauthToken: oauthToken,
            socialAccessToken: accessToken,
            membershipRequired: true
        )
        view?.display(viewModel: viewModel)
    }
    
    // 카카오 로그인 실패를 View에 전달
    func presentKakaoLoginFailure(_ loginState: Bool, accessToken: String) {
        // ViewModel을 생성하여 View에 전달
        let viewModel = LoginUseCase.LoadLogin.LoginPresentationViewModel(
            socialLoginType: "kakao",
            oauthToken: accessToken,
            socialAccessToken: nil,
            membershipRequired: false
        )
        view?.display(viewModel: viewModel)
    }
    
    // 분위기 정보를 View에 전달
    func presentVibes(_ vibes: [Vibe]) {
        let viewModel = LoginUseCase.LoadLogin.VibesPresentationViewModel(vibes: vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    // 분위기 정보를 가져오는 데 실패했을 때 View에 에러를 전달
    func presentVibesFetchFailure(_ error: Error) {
        print("Error fetching vibes: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }
}
