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
import Foundation
import AuthenticationServices
import Combine

protocol LoginBusinessLogic {
    func handleKakaoLogin()
    func handleKakaoLogout()
    func snapFitJoin(request: Login.LoadLogin.Request)
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest)
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>)
    //func handleAppleLogout()

}

final class LoginInteractor: LoginBusinessLogic {

    
    
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: LoginPresentationLogic?
    private let authWorker: AuthWorkingLogic
    
    init(authWorker: AuthWorkingLogic) {
        self.authWorker = authWorker
    }
    
    
    
    // MARK: - Step 1
    /// 실제 카카오 서버에 로그인 요청 후 인증 토큰을 가져오는 메서드
    /// userMemberVerification를 호출하여 우리 서버에 이미 회원가입 된 사용자인지 확인
    func handleKakaoLogin() {
        authWorker.handleKakaoLogin { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.userMemberVerification(accessToken: accessToken)
            case .failure(let error):
                self.presenter?.presentLoginFailure(error)
            }
        }
    }
    
    // MARK: - Step 2
    /// 카카오, 애플 로그인 버튼을 눌렀을때 이미 실 서버에 가입이 되어있는지 확인하는 메서드 입니다
    func userMemberVerification(accessToken: String) {
        authWorker.userMemberVerification { [weak self] verification in
            guard let self = self else { return }
            switch verification { // 회원 가입한 사용자인지 확인 참/거짓을 반환
            case .success(let isVerified):
                if isVerified {
                    let request = Login.LoadLogin.Request(
                        social: "",
                        nickName: "",
                        isMarketing: true,
                        oauthToken: accessToken,
                        moods: [""]
                    )
                    self.snapFitKakaoLogin(request: request) // 이미 회원가입한 사람이라면 로그인로직 처리
                }
                else {
                    self.presenter?.presentKakaoLoginFailure(false, accessToken: accessToken)
                }
            case .failure(let error):
                print("userMemberVerification \(error)")
                self.presenter?.presentLoginFailure(error)
            }
        }
    }
    
    // MARK: - Step 1
    // 스냅핏 서버에 카카오로그인을 요청
    func snapFitKakaoLogin(request: Login.LoadLogin.Request) {
        authWorker.userKakaoLogin(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle completion
                    break
                case .failure(let error):
                    self.presenter?.presentLoginFailure(error)
                    print("젠장 error \(error)")
                }
            }, receiveValue: { tokens in
                self.saveTokens(tokens)
                print("userKakaoLogin receiveValue \(tokens)")
                self.presenter?.presentKakaoLoginSuccess(true)
            })
            .store(in: &cancellables)
    }

    
    // 카카오, 애플로그인에 따라 스냅핏 서버에서 받는 토큰 값을 저장하는 메서드
    private func saveTokens(_ tokens: Tokens) {
        // Save tokens
        UserDefaults.standard.set(tokens.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(tokens.refreshToken, forKey: "refreshToken")

        // Verify if the tokens were saved correctly
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
            print("Saved accessToken: \(accessToken)")
            print("Saved refreshToken: \(refreshToken)")
        } else {
            print("Failed to save tokens")
        }
    }
    
    
    func handleKakaoLogout() {
        authWorker.handleKakaoLogout { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentKakaoLogoutSuccess()
            case .failure(let error):
                print("handleKakaoLogout \(error)")
                //self.presenter?.presentLoginFailure(error)
            }
        }
    }
    
    // MARK: - Step 1
    // 스냅핏 서버에 회원가입 요청
    func snapFitJoin(request: Login.LoadLogin.Request) {
        authWorker.createUser(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle completion
                    break
                case .failure(let error):
                    self.presenter?.presentLoginFailure(error)
                    print("젠장 error \(error)")
                }
            }, receiveValue: { tokens in
                self.saveTokens(tokens)
                print("userKakaoLogin receiveValue \(tokens)")
                self.presenter?.presentKakaoLoginSuccess(true)
            })
            .store(in: &cancellables)
    }
    
    
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
        authWorker.handleAppleLogin(request: request)
    }
    
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>) {
        authWorker.handleAppleLoginCompletion(result: result) { [weak self] completionResult in
            switch completionResult {
            case .success(let appleIDCredential):
                //self?.presenter?.presentAppleLoginSuccess(appleIDCredential)
                print("")
            case .failure(let error):
                //self?.presenter?.presentAppleLoginFailure(error)
                print("")
            }
        }
    }
    
//    func handleAppleLogout() {
//        authWorker.handleAppleLogout { [weak self] result in
//            switch result {
//            case .success:
//                self?.presenter?.presentAppleLogoutSuccess()
//            case .failure(let error):
//                self?.presenter?.presentAppleLogoutFailure(error)
//            }
//        }
//    }
}

