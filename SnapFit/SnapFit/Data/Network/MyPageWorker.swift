//
//  MyPageWorker.swift
//  SnapFit
//
//  Created by 정정욱 on 8/18/24.
//


import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Combine
import CombineExt
import MultipartForm

// MyPageWorker의 기능을 정의하는 프로토콜
protocol MyPageWorkingLogic {
    
    
    // MARK: - 유저 정보 조회 관련
    func fetchUserDetails() -> AnyPublisher<UserDetailsResponse, ApiError>
    func fetchLikeCount() -> AnyPublisher<LikeCountResponse, ApiError>
    func fetchReservationCount() -> AnyPublisher<ReservationCountResponse, ApiError> 
    
    // MARK: - 상품 예약확인 관련
    func fetchUserReservations(limit: Int, offset: Int) -> AnyPublisher<ReservationResponse, ApiError>
    func fetchReservationDetail(id: Int) -> AnyPublisher<ReservationDetailsResponse, ApiError>
    
    // MARK: - 상품 찜 관련
    func fetchUserLikes(limit: Int, offset: Int) -> AnyPublisher<ReservationResponse, ApiError>
    
    
    // 상품 찜하기
    func likePost(postId: Int) -> AnyPublisher<Void, ApiError>
    func unlikePost(postId: Int) -> AnyPublisher<Void, ApiError> 
}

class MyPageWorker: MyPageWorkingLogic {
    
    static let baseURL = "http://34.47.94.218/snapfit" // 서버 주소
    
    func fetchUserDetails() -> AnyPublisher<UserDetailsResponse, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        
        let urlString = "http://34.47.94.218/snapfit/user"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> UserDetailsResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let response = try JSONDecoder().decode(UserDetailsResponse.self, from: data)
                    return response
                case 400...403:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - 예약, 찜 카운트 값 가져오기
    
    // Like Count API 호출
    func fetchLikeCount() -> AnyPublisher<LikeCountResponse, ApiError> {
        let urlString = "http://34.47.94.218/snapfit/post/like/count"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> LikeCountResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let response = try JSONDecoder().decode(LikeCountResponse.self, from: data)
                    return response
                case 400...403:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }

    // Reservation Count API 호출
    func fetchReservationCount() -> AnyPublisher<ReservationCountResponse, ApiError> {
        let urlString = "http://34.47.94.218/snapfit/reservation/count"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationCountResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let response = try JSONDecoder().decode(ReservationCountResponse.self, from: data)
                    return response
                case 400...403:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    // AccessToken 가져오기
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    // MARK: - 유저 예약 내역 조회

    func fetchUserReservations(limit: Int = 10, offset: Int = 0) -> AnyPublisher<ReservationResponse, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/reservation/user?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let response = try JSONDecoder().decode(ReservationResponse.self, from: data)
                    return response
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetchUserLikes(limit: Int = 10, offset: Int = 0) -> AnyPublisher<ReservationResponse, ApiError> {
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }

        // API 호출을 위한 URL
        let urlString = "http://34.47.94.218/snafit/post/like?limit=\(limit)&offset=\(offset)"
        
        // URL 문자열을 URL 객체로 변환
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }

        // URL 요청 설정
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // URLSession을 사용해 API 호출
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                // HTTP 응답 코드에 따라 처리
                switch httpResponse.statusCode {
                case 200...299:
                    // 성공적으로 데이터 받아오기
                    let response = try JSONDecoder().decode(ReservationResponse.self, from: data)
                    return response
                case 400...404:
                    // 오류 응답 처리
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 500:
                    // 서버 에러 처리
                    throw ApiError.serverError
                default:
                    // 기타 상태 코드 처리
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }

    

    func fetchReservationDetail(id: Int) -> AnyPublisher<ReservationDetailsResponse, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/reservation?id=\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Log the URLRequest details
        print("MyPage Request URL: \(urlRequest.url?.absoluteString ?? "No URL")")
        print("HTTP Method: \(urlRequest.httpMethod ?? "No Method")")
        print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("ID: \(id)") // Log the ID value
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationDetailsResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let response = try JSONDecoder().decode(ReservationDetailsResponse.self, from: data)
                    return response
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }

    
    
    // MARK: - 상품 좋아요
    
    func likePost(postId: Int) -> AnyPublisher<Void, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/post/like?postId=\(postId)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Void in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    func unlikePost(postId: Int) -> AnyPublisher<Void, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/post/like?postId=\(postId)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Void in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    throw ApiError.notFound
                case 500:
                    throw ApiError.serverError
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
}
