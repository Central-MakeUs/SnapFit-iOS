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
import Combine
import CombineExt
import MultipartForm

// API 통신 워커 기능 정의
final class AuthWorker {
    
    static let baseURL = "http://34.47.94.218/snapfit" // 서버 주소
    
   
    
    func handleKakaoLogin(completion: @escaping (Result<String, Error>) -> Void) {
         if UserApi.isKakaoTalkLoginAvailable() {
             UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                 if let error = error {
                     completion(.failure(error))
                 } else if let accessToken = oauthToken?.accessToken {
                     completion(.success(accessToken))
                 } else {
                     completion(.failure(NSError(domain: "AuthWorker", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token"])))
                 }
             }
         } else {
             UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                 if let error = error {
                     completion(.failure(error))
                 } else if let accessToken = oauthToken?.accessToken {
                     completion(.success(accessToken))
                 } else {
                     completion(.failure(NSError(domain: "AuthWorker", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token"])))
                 }
             }
         }
     }
    
    
    
    func createUser(with oauthToken: String, request: Login.LoadLogin.Request) -> AnyPublisher< Tokens, ApiError> {
        
        let urlString = AuthWorker.baseURL + "/signUp"

        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        //urlRequest.addValue(oauthToken, forHTTPHeaderField: "accessToken")
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")

        // JSON 요청 본문 생성
        let requestBody: [String: Any] = [
            "social": request.social,
            "vibes": ["테스트"],
            "deviceType": "apple",
            "deviceToken": oauthToken,
            "nickName": request.nickName,
            "marketing": request.isMarketing
        ]

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            return Fail(error: ApiError.jsonEncoding).eraseToAnyPublisher()
        }


        // 2. urlSession 으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                
                //print("data: \(data)")
                print("urlResponse: \(urlResponse)")
                     
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 204:
                    throw ApiError.noContent
                    
                default: print("default")
                }
                
                if !(200...299).contains(httpResponse.statusCode){
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: Tokens.self, decoder: JSONDecoder())
            .mapError({ err -> ApiError in
                if let error = err as? ApiError { // ApiError 라면
                    return error
                }
                
                if let _ = err as? DecodingError { // 디코딩 에러라면
                    return ApiError.decodingError
                }
                
                return ApiError.unknown(nil)
            }).eraseToAnyPublisher()
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
