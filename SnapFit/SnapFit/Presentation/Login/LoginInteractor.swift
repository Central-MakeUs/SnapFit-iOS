//
//  LoginInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import Foundation
import AuthenticationServices

/*
 Interactor 가 처리할 기능들을 정의
 */
protocol LoginBusinessLogic {
    func handleKakaoLogin()
    func handleKakaoLogout()
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest)
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>)
    func handleAppleLogout()
    func load(request: Login.LoadLogin.Request)
}

final class LoginInteractor: LoginBusinessLogic {
    
    var presenter: LoginPresentationLogic?
    private let authWorker = AuthWorker()

    func handleKakaoLogin() {
        authWorker.handleKakaoLogin { [weak self] result in
            switch result {
            case .success(let oauthToken):
                self?.presenter?.presentKakaoLoginSuccess(oauthToken)
            case .failure(let error):
                self?.presenter?.presentKakaoLoginFailure(error)
            }
        }
    }

    func handleKakaoLogout() {
        authWorker.handleKakaoLogout { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentKakaoLogoutSuccess()
            case .failure(let error):
                self?.presenter?.presentKakaoLoginFailure(error)
            }
        }
    }
    
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
        authWorker.handleAppleLogin(request: request)
    }

    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>) {
        authWorker.handleAppleLoginCompletion(result: result) { [weak self] completionResult in
            switch completionResult {
            case .success(let appleIDCredential):
                self?.presenter?.presentAppleLoginSuccess(appleIDCredential)
            case .failure(let error):
                self?.presenter?.presentAppleLoginFailure(error)
            }
        }
    }

    func handleAppleLogout() {
        authWorker.handleAppleLogout { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentAppleLogoutSuccess()
            case .failure(let error):
                self?.presenter?.presentAppleLogoutFailure(error)
            }
        }
    }
    
    func load(request: Login.LoadLogin.Request) {
        // Load logic
    }
}
