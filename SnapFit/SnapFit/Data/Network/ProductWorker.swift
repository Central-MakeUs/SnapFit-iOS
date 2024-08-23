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
    
    
    // MARK: - 유저 정보 가져오기
    func fetchUserDetails() -> AnyPublisher<UserDetailsResponse, ApiError>
    
    // MARK: - 상품 예약관련
    func fetchProductsFromServer(limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    func fetchProductsFromServerWithFilter(vibes: String, limit: Int, offset: Int) -> AnyPublisher<Product, ApiError> // 분위기값 서버에서 가져오기
    func fetchProductsForMaker(userId: Int, limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    func fetchPostDetailById(postId: Int) -> AnyPublisher<PostDetailResponse, ApiError>
    func fetchVibes() -> AnyPublisher<Vibes, ApiError>
    
    // MARK: - 상품 예약관련
    func makeReservation(reservation: ReservationRequest) -> AnyPublisher<ReservationDetailsResponse, ApiError>
    func fetchUserReservations(limit: Int, offset: Int) -> AnyPublisher<ReservationResponse, ApiError>
    func fetchReservationDetail(id: Int) -> AnyPublisher<ReservationDetailsResponse, ApiError>
    func deleteReservation(id: Int, message: String) -> AnyPublisher<Bool, ApiError>
    
    // 상품 찜하기
    func likePost(postId: Int) -> AnyPublisher<Void, ApiError>
    func unlikePost(postId: Int) -> AnyPublisher<Void, ApiError> 
  
}

class ProductWorker: ProductWorkingLogic {
    
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
        let urlString = "http://34.47.94.218/snapfit/posts/maker?limit=\(limit)&offset=\(offset)&userId=\(userId)"
        
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
    func makeReservation(reservation: ReservationRequest) -> AnyPublisher<ReservationDetailsResponse, ApiError> {
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
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationDetailsResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // 성공적인 응답 코드 범위
                    let response = try JSONDecoder().decode(ReservationDetailsResponse.self, from: data)
                    
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

    
    // 유저 예약 상세 조회


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
        print("Request URL: \(urlRequest.url?.absoluteString ?? "No URL")")
        print("HTTP Method: \(urlRequest.httpMethod ?? "No Method")")
        print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("ID: \(id)") // Log the ID value

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationDetailsResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }

                // Log the HTTP response details
                print("Response Status Code: \(httpResponse.statusCode)")

                switch httpResponse.statusCode {
                case 200...299:
                    return try JSONDecoder().decode(ReservationDetailsResponse.self, from: data)
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Not Found"
                    throw ApiError.notFoundMessage(message: message) // 404 오류 메시지 포함
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

    // MARK: - 예약 취소
    
    func deleteReservation(id: Int, message: String) -> AnyPublisher<Bool, ApiError> {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // URL 인코딩을 추가하여 메시지와 아이디를 URL에 포함
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
        let urlString = "http://34.47.94.218/snapfit/reservation?id=\(id)&message=\(encodedMessage)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
   
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Bool in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                // Log the HTTP response details
                print("Response Status Code: \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                case 200...299:
                    return true
                case 400:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Not Found"
                    throw ApiError.notFoundMessage(message: message)
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
