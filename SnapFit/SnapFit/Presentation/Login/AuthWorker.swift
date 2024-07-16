//
//  AuthWorker.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

// API 통신 워커 기능 정의 
final class AuthWorker {
    func handleKakaoLogin(completion: @escaping (Result<OAuthToken?, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(oauthToken))
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(oauthToken))
                }
            }
        }
    }

    func handleKakaoLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.logout { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>, completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                completion(.success(appleIDCredential))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID Credential"])))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func handleAppleLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        // 예시로, 클라이언트 측에서는 로그아웃 시 로컬 데이터를 초기화하는 것을 보여줍니다.
        // 실제로는 Apple ID 자격 증명과 관련된 데이터를 서버에서도 삭제해야 할 수 있습니다.
        
        // 클라이언트 측에서는 Apple ID 자격 증명 및 관련 데이터를 초기화합니다.
        // 예시로 isAppleLoggedIn과 appleUserIdentifier를 초기화합니다.
        UserDefaults.standard.removeObject(forKey: "appleUserIdentifier")
        completion(.success(()))
    }
}
