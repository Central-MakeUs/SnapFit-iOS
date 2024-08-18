//
//  ProductWorker.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//


import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Combine
import CombineExt
import MultipartForm

// AuthWorker의 기능을 정의하는 프로토콜
protocol ProductWorkingLogic {
    
    // MARK: - 상품 예약관련
    func fetchProductsFromServer(limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    func fetchProductsFromServerWithFilter(vibes: String, limit: Int, offset: Int) -> AnyPublisher<Product, ApiError> // 분위기값 서버에서 가져오기
    func fetchProductsForMaker(userId: Int, limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    func fetchPostDetailById(postId: Int) -> AnyPublisher<PostDetailResponse, ApiError>
    func fetchVibes() -> AnyPublisher<Vibes, ApiError>
    
    // MARK: - 상품 예약관련
    func makeReservation(reservation: ReservationRequest) -> AnyPublisher<ShortTermReservationResponse, ApiError>
    func fetchUserReservations(limit: Int, offset: Int) -> AnyPublisher<ReservationResponse, ApiError>
}

class ProductWorker: ProductWorkingLogic {
    
    static let baseURL = "http://34.47.94.218/snapfit" // 서버 주소
    
    
    
    
    // MARK: - 메인 뷰 상품 가져오기
    func fetchProductsFromServer(limit: Int = 10, offset: Int = 0) -> AnyPublisher<Product, ApiError> {
        print("워커 진입")
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/posts/all?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Fetching posts with accessToken: \(accessToken)")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    throw ApiError.invalidRefreshToken
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Product.self, decoder: JSONDecoder())
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
    
    // MARK: - 메인 뷰 필터에 맞게 상품 가져오기
    func fetchProductsFromServerWithFilter(vibes: String, limit: Int = 10, offset: Int = 0) -> AnyPublisher<Product, ApiError> {
        print("fetchProductsFromServerWithFilter 워커 진입")
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // URL에 필터 파라미터 추가
        let urlString = "http://34.47.94.218/snapfit/posts/filter/vibes?vibes=\(vibes)&limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Fetching posts with accessToken: \(accessToken)")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    throw ApiError.invalidRefreshToken
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Product.self, decoder: JSONDecoder())
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
    
    
    // 메이커가 등록한 상품 가져오기
    func fetchProductsForMaker(userId: Int, limit: Int = 10, offset: Int = 0) -> AnyPublisher<Product, ApiError> {
        print("fetchProductsForMaker 함수 진입")
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // 요청할 URL 생성
        let urlString = "http://34.47.94.218/snafit/posts/maker?limit=\(limit)&offset=\(offset)&userId=\(userId)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Fetching maker's products with accessToken: \(accessToken)")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    throw ApiError.invalidRefreshToken
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Product.self, decoder: JSONDecoder())
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

    // 각상품별 디테일 정보 가져오기
    func fetchPostDetailById(postId: Int) -> AnyPublisher<PostDetailResponse, ApiError> {
        print("fetchPostDetailById 함수 진입")
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // 요청할 URL 생성
        let urlString = "http://34.47.94.218/snapfit/post?id=\(postId)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Fetching post details with accessToken: \(accessToken)")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    throw ApiError.invalidRefreshToken
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: PostDetailResponse.self, decoder: JSONDecoder())
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
    
    
    
    // MARK: - 상품예약

    // MARK: - 예약 요청을 서버로 보내는 함수
    func makeReservation(reservation: ReservationRequest) -> AnyPublisher<ShortTermReservationResponse, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        print("reservation \(reservation)")
        
        let urlString = "http://34.47.94.218/snapfit/reservation"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        do {
            let jsonData = try JSONEncoder().encode(reservation)
            urlRequest.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
        } catch {
            return Fail(error: ApiError.encodingError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ShortTermReservationResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // 성공적인 응답 코드 범위
                    let response = try JSONDecoder().decode(ShortTermReservationResponse.self, from: data)
                    
                    // 응답 데이터 유효성 검증 (옵셔널 필드 검사)
                    guard response.id != nil, response.user != nil, response.post != nil else {
                        throw ApiError.unknown(nil)
                    }
                    
                    return response // 성공시 예약 응답 반환
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    throw ApiError.invalidRefreshToken
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




}
