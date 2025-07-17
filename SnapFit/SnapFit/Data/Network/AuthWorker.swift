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



// AuthWorker의 기능을 정의하는 프로토콜
protocol AuthWorkingLogic {
    
    // 로그인
    func loginWithKakao(completion: @escaping (Result<String, Error>) -> Void)
    func socialLoginSnapfitServer(accessToken: String, socialType: String) -> AnyPublisher<Tokens, ApiError>
    func initiateAppleLogin(request: ASAuthorizationAppleIDRequest)
    func completeAppleLogin(result: Result<ASAuthorization, Error>, completion: @escaping (Result<String, Error>) -> Void)
    
    // 회원 가입
    func fetchVibes() -> AnyPublisher<Vibes, ApiError>
    func registerUser(request: LoginUseCase.LoadLogin.Request) -> AnyPublisher<Tokens, ApiError>
    
    // 로그아웃, 탈퇴
    func logoutFromKakao(completion: @escaping (Result<Void, Error>) -> Void)
    func socialLogoutSnapfitServer() -> AnyPublisher<Bool, ApiError>
    func deleteUserAccount() -> AnyPublisher<Bool, ApiError>
    
    // 토큰 만료
    func refreshToken() -> AnyPublisher<Tokens, ApiError>
    
}

class AuthWorker: AuthWorkingLogic {
    
    static let baseURL = "http://34.47.94.218/snapfit" // 서버 주소

    // MARK: - 카카오 로그인 처리
    func loginWithKakao(completion: @escaping (Result<String, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡을 통한 로그인
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
            // 카카오 계정을 통한 로그인
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
    
    // MARK: - 스냅핏 서버에 사용자 등록 요청
    func registerUser(request: LoginUseCase.LoadLogin.Request) -> AnyPublisher<Tokens, ApiError> {
        let urlString = AuthWorker.baseURL + "/user"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(request.socialAccessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        // JSON 요청 본문 생성
        let requestBody: [String: Any] = [
            "social": request.social,
            "vibes": request.moods,
            "deviceType": "apple",
            "deviceToken": "abcdefg", // 실제 기계 토큰으로 변경 필요
            "nickName": request.nickName,
            "marketing": request.isMarketing
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            return Fail(error: ApiError.jsonEncoding).eraseToAnyPublisher()
        }
        
        // API 호출 및 응답 처리
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case (400...404):
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 204:
                    throw ApiError.noContent
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Tokens.self, decoder: JSONDecoder())
            .mapError { err in
                if let apiError = err as? ApiError {
                    return apiError
                }
                if let _ = err as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(nil)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 카카오, 애플계정으로 스냅핏 서버에 사용자 로그인
    func socialLoginSnapfitServer(accessToken: String, socialType: String) -> AnyPublisher<Tokens, ApiError> {
         // socialType을 URL에 포함시킴
         let urlString = AuthWorker.baseURL + "/login?SocialType=\(socialType)"
         
         guard let url = URL(string: urlString) else {
             return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
         }
         
         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = "GET"
         urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
         urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
         
         print("accessToken \(accessToken) for socialType \(socialType)")
         
         // API 호출 및 응답 처리
         return URLSession.shared.dataTaskPublisher(for: urlRequest)
             .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                 guard let httpResponse = urlResponse as? HTTPURLResponse else {
                     throw ApiError.unknown(nil)
                 }
                 
                 switch httpResponse.statusCode {
                 case (400...404):
                     let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                     let message = errorResponse?.message ?? "Bad Request"
                     let errorCode = errorResponse?.errorCode ?? 0
                     throw ApiError.badRequest(message: message, errorCode: errorCode)
                 case 204:
                     throw ApiError.noContent
                 default:
                     if !(200...299).contains(httpResponse.statusCode) {
                         throw ApiError.badStatus(code: httpResponse.statusCode)
                     }
                 }
                 
                 return data
             }
             .decode(type: Tokens.self, decoder: JSONDecoder())
             .mapError { err in
                 if let apiError = err as? ApiError {
                     return apiError
                 }
                 if let _ = err as? DecodingError {
                     return ApiError.decodingError
                 }
                 return ApiError.unknown(nil)
             }
             .eraseToAnyPublisher()
     }
     

    // MARK: - 카카오, 애플계정으로 스냅핏 서버에 사용자 로그아웃
    func socialLogoutSnapfitServer() -> AnyPublisher<Bool, ApiError> {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
              let savedRefreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            return Fail(error: ApiError.invalidAccessToken).eraseToAnyPublisher()
        }
        
        print("로그아웃 accessToken \(accessToken)")
        print("로그아웃 savedRefreshToken \(savedRefreshToken)")
        
        // URL 인코딩 추가
        //let encodedRefreshToken = savedRefreshToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? savedRefreshToken
        let urlString = AuthWorker.baseURL + "/logout?refreshToken=\(savedRefreshToken)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("*/*", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        //urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
        // 빈 데이터 설정
        urlRequest.httpBody = Data()
        
        // 요청 헤더와 바디 출력
        print("로그아웃 요청 URL: \(urlRequest.url?.absoluteString ?? "URL 없음")")
        print("로그아웃 요청 HTTP 메서드: \(urlRequest.httpMethod ?? "메서드 없음")")
        print("로그아웃 요청 헤더: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let httpBody = urlRequest.httpBody, !httpBody.isEmpty {
            print("로그아웃 요청 바디: \(String(data: httpBody, encoding: .utf8) ?? "바디 없음")")
        } else {
            print("로그아웃 요청 바디: 빈 바디")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    self.clearTokens() // 로그아웃 성공 시 토큰 삭제
                    return true
                } else if httpResponse.statusCode == 404 {
                    throw ApiError.badRequest(message: "Endpoint not found", errorCode: 404)
                } else if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? httpResponse.statusCode
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                } else {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                } else {
                    return ApiError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }




    // MARK: - Refresh Token
    func refreshToken() -> AnyPublisher<Tokens, ApiError> {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = AuthWorker.baseURL + "/refresh/token?refreshToken=\(refreshToken)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                if httpResponse.statusCode == 401 {
                    throw ApiError.invalidRefreshToken
                } else if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return output.data
            }
            .decode(type: Tokens.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                } else {
                    return ApiError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - 사용자 탈퇴
    func deleteUserAccount() -> AnyPublisher<Bool, ApiError> {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            return Fail(error: ApiError.invalidAccessToken).eraseToAnyPublisher()
        }
        
        let urlString = AuthWorker.baseURL + "/user"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    self.clearTokens() // 탈퇴 성공 시 토큰 삭제
                    return true
                } else if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? httpResponse.statusCode
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                } else {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                } else {
                    return ApiError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - UserDefaults에서 저장된 토큰 삭제
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        print("Tokens have been cleared from UserDefaults")
    }

    // MARK: - 카카오 로그아웃 처리
    func logoutFromKakao(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.logout { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - 애플 로그인 요청 초기화
    func initiateAppleLogin(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

 
    // MARK: - 애플 로그인 완료 처리
    func completeAppleLogin(result: Result<ASAuthorization, Error>, completion: @escaping (Result<String, Error>) -> Void) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                if let identityToken = appleIDCredential.identityToken,
                   let tokenString = String(data: identityToken, encoding: .utf8) {
                    completion(.success(tokenString))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID Credential"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID Credential"])))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    // MARK: - 분위기 가져오기
    func fetchVibes() -> AnyPublisher<Vibes, ApiError> {
        let urlString = AuthWorker.baseURL + "/vibes"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        
        // API 호출 및 응답 처리
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case (400...404):
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Vibes.self, decoder: JSONDecoder())
            .mapError { err in
                if let apiError = err as? ApiError {
                    return apiError
                }
                if let _ = err as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(nil)
            }
            .eraseToAnyPublisher()
    }
}
