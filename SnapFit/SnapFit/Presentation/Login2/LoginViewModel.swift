//
//  kakaoAuthViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/11/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

class LoginViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    @Published var isKakaoLogin = false
    @Published var isKakaoLogout = false
    
    @Published var isAppleLoggedIn = false // Apple 로그인 상태를 추적하는 상태 변수
    @Published var appleUserIdentifier: String? = nil // Apple 사용자 식별자를 추적하는 상태 변수

    /*
     애플로그인 플로우
     ios > 애플서버 > 응답받음(id token) > 우리 서버로 전송 - 클라
     > 우리서버에서 검증 후 access(서비스 접근 권한), refresh(토큰 만료기간 지나면 다시 접근하기 위한) token 전송 - 서버
     > 서버 다시 준 토큰 ios 에서 받고 키체인 등 저장해서
     
     토큰 검증 절차 -> 스플레시뷰에서 토큰 검증 요청해서 유요하면 메인뷰, 만료 면 리프레시토큰 가지고 엑시스 토큰 다시 만들기
     리프레시토큰도 유효하지 않았을때는 로그인화면으로
     
     근데 주의하실점은 맨 처음 로그인시에만 이름값 뽑을 수 있어요
     두번째부턴 nickname에 nil들어가요
     
     // 무무 - 토큰 보통 키체인에 저장, Or 로컬DB
     
     
     */
     
 
     
     
    func handleKakaoLogin() {
        
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            // 카카오 앱을 통해 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }else{ // 카카오톡이 설치 되어 있지 않을때
            // 카카오 웹뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                    }
                }
        }
    }
    
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // 계정 정보 가져오기
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                let email = appleIDCredential.email
                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                
                // 로그인 상태 업데이트
                self.isAppleLoggedIn = true
                self.appleUserIdentifier = userIdentifier

            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("Apple Login Error")
        }
    }
    
    func handleAppleLogout() {
        // Apple 로그인 관련 사용자 정보를 지우는 로직
        isAppleLoggedIn = false
        appleUserIdentifier = nil
        // 추가적으로 키체인이나 로컬 저장소에서 데이터 삭제 필요
        print("Apple Logout Successful")
    }

}
