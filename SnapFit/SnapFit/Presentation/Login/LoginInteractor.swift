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

protocol LoginBusinessLogic {
    func loginWithKakao()
    func logoutFromKakao()
    func registerSnapFitUser(request: Login.LoadLogin.Request)
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest)
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>)
    //func handleAppleLogout()
    
    func fetchVibes()
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
    func loginWithKakao() {
        authWorker.loginWithKakao { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let kakaoAccessToken):
                self.loginKakaoSnapFitUser(kakaoAccessToken: kakaoAccessToken)
            case .failure(let error):
                self.presenter?.presentLoginFailure(error)
            }
        }
    }
    
    
    
    // MARK: - Step 2
    // 스냅핏 서버에 카카오로그인을 요청
    // 이미 사용자가 있으면 presenter를 통해 accessToken을 전달 (회원 가입 처리를 위해)
    // 성공해서 서버에서 tokens을 받았다면 로컬에 저장 후 presenter에게 알림
    func loginKakaoSnapFitUser(kakaoAccessToken: String) {
        authWorker.loginUserWithKakao(kakaoAccessToken: kakaoAccessToken)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle completion
                    break
                case .failure(let error):
                    self.presenter?.presentAlreadyregisteredusers(kakaoAccessToken, error)
                    print("젠장 error \(error)") // 사용자가 존재하면
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
    
    
    func logoutFromKakao() {
        authWorker.logoutFromKakao { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentKakaoLogoutSuccess()
            case .failure(let error):
                print("handleKakaoLogout \(error)")
                //self.presenter?.presentLoginFailure(error)
            }
        }
    }
    
    // MARK: - Step 3 (회원이 아닐때)
    // 스냅핏 서버에 회원가입 요청 (뷰를 통해 다시 들어옴)
    func registerSnapFitUser(request: Login.LoadLogin.Request) {
        authWorker.registerUser(request: request)
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
        authWorker.initiateAppleLogin(request: request)
    }
    
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>) {
      
        authWorker.completeAppleLogin(result: result) { [weak self] completionResult in
            switch completionResult {
            case .success(let identityToken):
                //self?.presenter?.presentAppleLoginSuccess(appleIDCredential)
                print("identityToken \(identityToken)")
            case .failure(let error):
                //self?.presenter?.presentAppleLoginFailure(error)
                print("실패임ㅋ")
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
    
    func fetchVibes() {
        print("fetchVibes 호출 완료")
         authWorker.fetchVibes()
             .sink(receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     // Completion 시 추가적인 처리가 필요하다면 여기서 처리
                     break
                 case .failure(let error):
                     self.presenter?.presentVibesFetchFailure(error)
                     print("젠장 error \(error)")
                 }
             }, receiveValue: { vibes in
                 print("Fetched Vibes: \(vibes)")
                 self.presenter?.presentVibes(vibes)
             })
             .store(in: &cancellables)
     }
    
}

