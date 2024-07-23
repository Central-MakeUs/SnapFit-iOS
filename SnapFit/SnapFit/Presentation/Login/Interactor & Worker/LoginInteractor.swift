//
//  LoginInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import Foundation
import AuthenticationServices
import Combine

/*
 Interactor 가 처리할 기능들을 정의
 */
protocol LoginBusinessLogic {
    func handleKakaoLogin()
    func handleKakaoLogout()
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest)
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>)
    func handleAppleLogout()

    func userCreated(request: Login.LoadLogin.Request)
}

final class LoginInteractor: LoginBusinessLogic {
   
    private var cancellables = Set<AnyCancellable>()

    
    // 실서버 통신
    func userCreated(request: Login.LoadLogin.Request) {
        guard let token = oauthToken else {
            // handle error: token is not available
            return
        }
        
        authWorker.createUser(with: token, request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle completion
                    break
                case .failure(let error):
                    self.presenter?.presentUserCreationFailed(error)
                    print("젠장 error \(error)")
                }
            }, receiveValue: { tokens in
                // Save tokens
                UserDefaults.standard.set(tokens.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(tokens.refreshToken, forKey: "refreshToken")
                print("userCreated receiveValue \(tokens)")
                self.presenter?.presentUserCreated(tokens)
            })
            .store(in: &cancellables)
    }
    
    
    var presenter: LoginPresentationLogic?
    private let authWorker = AuthWorker()

    private var oauthToken: String?
    
    func handleKakaoLogin() {
        authWorker.handleKakaoLogin { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.oauthToken = accessToken // accessToken 저장
                print(self?.oauthToken)
                self?.presenter?.presentKakaoLoginSuccess(self?.oauthToken)
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

}
