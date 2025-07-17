import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

// 로그인 비즈니스 로직을 정의하는 프로토콜
protocol LoginBusinessLogic {
    func loginWithKakao()  // 카카오 로그인 처리
    func loginWithApple(request: ASAuthorizationAppleIDRequest)  // 애플 로그인 처리
    func completeAppleLogin(result: Result<ASAuthorization, Error>)  // 애플 로그인 완료 처리
    func registerUser(request: LoginUseCase.LoadLogin.Request)  // 사용자 등록
    func fetchVibes()  // 분위기 정보 가져오기
}

class LoginInteractor: LoginBusinessLogic {
    
    var presenter: LoginPresentationLogic?  // Presenter와의 통신을 위한 참조
    
    private let authWorker: AuthWorkingLogic
    
    init(authWorker: AuthWorkingLogic) {
        self.authWorker = authWorker
    }
    
    
    private var cancellables = Set<AnyCancellable>()  // Combine 구독 관리를 위한 Set
    
    // 카카오 로그인 처리
    func loginWithKakao() {
        authWorker.loginWithKakao { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.authWorker.socialLoginSnapfitServer(accessToken: accessToken, socialType: "kakao")
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            self?.presenter?.presentSocialLoginFailure(error, socialLoginType: "kakao", accessToken: accessToken) // 존재하지 않으면 기존 애플, 카카오 엑세스 토큰 전달 뷰 모델로 -> 회원가입 로직
                        case .finished:
                            break
                        }
                    }, receiveValue: { tokens in //유저가 존재하면 토큰값 저장 후 메인뷰 전환
                        // 1. 토큰을 저장
                        self?.saveTokens(tokens)
                        self?.presenter?.presentSocialLoginSuccess(socialLoginType: "kakao", accessToken: accessToken, oauthToken: nil)
                    })
                    .store(in: &self!.cancellables)
                
            case .failure(let error):
                self?.presenter?.presentKakaoLoginFailure(false, accessToken: "")
            }
        }
    }
    
    // 애플 로그인 요청 초기화
    func loginWithApple(request: ASAuthorizationAppleIDRequest) {
        authWorker.initiateAppleLogin(request: request)
    }
    
    // 애플 로그인 완료 처리
    func completeAppleLogin(result: Result<ASAuthorization, Error>) {
        authWorker.completeAppleLogin(result: result) { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.authWorker.socialLoginSnapfitServer(accessToken: accessToken, socialType : "apple")
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error): // 실패시 애플에서 받은 엑세스 토큰을 저장
                            self?.presenter?.presentSocialLoginFailure(error, socialLoginType: "apple", accessToken: accessToken)
                        case .finished:
                            break
                        }
                    }, receiveValue: { tokens in
                        // 1. 애플 로그인 성공시 스냅핏 토큰을 저장
                        self?.saveTokens(tokens)
                        self?.presenter?.presentSocialLoginSuccess(socialLoginType: "apple", accessToken: accessToken, oauthToken: nil)
                    })
                    .store(in: &self!.cancellables)
                
            case .failure(let error):
                self?.presenter?.presentSocialLoginFailure(error, socialLoginType: "apple", accessToken: "애플로그인 실패")
            }
        }
    }
    
    // 사용자 등록 처리
    func registerUser(request: LoginUseCase.LoadLogin.Request) {
        authWorker.registerUser(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentSocialregisterFailure(error, socialLoginType: request.social, accessToken: request.socialAccessToken, oauthToken: nil)
                case .finished:
                    break
                }
            }, receiveValue: { tokens in
                self.saveTokens(tokens)
                // 옵셔널 값 처리: `accessToken`이 옵셔널이므로 `??`를 사용해 기본값을 제공
                let accessToken = tokens.accessToken ?? ""
                self.presenter?.presentSocialregisterSuccess(socialLoginType: request.social, accessToken: accessToken, oauthToken: nil)
            })
            .store(in: &cancellables)
    }
    
    // 분위기 정보 가져오기
    func fetchVibes() {
        authWorker.fetchVibes()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentVibesFetchFailure(error)
                case .finished:
                    break
                }
            }, receiveValue: { vibes in
                self.presenter?.presentVibes(vibes)
            })
            .store(in: &cancellables)
    }
    
    // 토큰 저장
    private func saveTokens(_ tokens: Tokens) {
        // 옵셔널 값 처리: `accessToken`과 `refreshToken`이 옵셔널이므로 기본값을 제공
        let accessToken = tokens.accessToken ?? ""
        let refreshToken = tokens.refreshToken ?? ""
        
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
    }
}
