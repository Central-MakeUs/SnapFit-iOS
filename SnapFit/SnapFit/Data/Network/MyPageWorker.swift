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
    func deleteReservation(id: Int, message: String) -> AnyPublisher<Bool, ApiError>
    
    // MARK: - 상품 찜 관련
    func fetchUserLikes(limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    
    
    // 상품 찜하기
    func likePost(postId: Int) -> AnyPublisher<Void, ApiError>
    func unlikePost(postId: Int) -> AnyPublisher<Void, ApiError> 
    func fetchProductsForMaker(userId: Int, limit: Int, offset: Int) -> AnyPublisher<Product, ApiError>
    func fetchPostDetailById(postId: Int) -> AnyPublisher<PostDetailResponse, ApiError>
    
    
    // MARK: - 메이커 관련 기능
    func fetchMakerPosts(userId: Int, limit: Int, offset: Int) -> AnyPublisher<MakerProductResponse, ApiError>
    func fetchVibes() -> AnyPublisher<Vibes, ApiError>
    func fetchLocations() -> AnyPublisher<MakerLocations, ApiError>
    func uploadImages(fileInfos: [ImageInfoResponse.FileInfo], images: [Data]) -> AnyPublisher<[String], ApiError> 
    func fetchImagePaths(ext: String) -> AnyPublisher<[ImageInfoResponse.FileInfo], ApiError>
    func postProduct(request: MakerProductRequest) -> AnyPublisher<PostProductResponse, ApiError>
    func fetchMakerReservations(limit: Int, offset: Int) -> AnyPublisher<ReservationResponse, ApiError>
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
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
        
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
    
    
    func fetchUserLikes(limit: Int = 10, offset: Int = 0) -> AnyPublisher<Product, ApiError> {
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }

        // API 호출을 위한 URL
        let urlString = "http://34.47.94.218/snapfit/post/like?limit=\(limit)&offset=\(offset)"
        
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
            .tryMap { (data: Data, urlResponse: URLResponse) -> Product in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                // HTTP 응답 코드에 따라 처리
                switch httpResponse.statusCode {
                case 200...299:
                    // 성공적으로 데이터 받아오기
                    do {
                        let response = try JSONDecoder().decode(Product.self, from: data)
                        return response
                    } catch {
                        print("Decoding error: \(error)")
                        throw ApiError.decodingError
                    }
                case 400...404:
                    // 오류 응답 처리
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let message = errorResponse.message ?? "Bad Request"
                        let errorCode = errorResponse.errorCode ?? 0
                        throw ApiError.badRequest(message: message, errorCode: errorCode)
                    } catch {
                        print("Decoding error response error: \(error)")
                        throw ApiError.decodingError
                    }
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
    
    
    
    
    
    
    // MARK: - 메이커 관련 기능
    
    // 메이커 상품 조회
    func fetchMakerPosts(userId: Int, limit: Int = 10, offset: Int = 0) -> AnyPublisher<MakerProductResponse, ApiError> {
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }

        // API 호출을 위한 URL
        let urlString = "http://34.47.94.218/snapfit/posts/maker?limit=\(limit)&offset=\(offset)&userId=\(userId)"
        
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
            .tryMap { (data: Data, urlResponse: URLResponse) -> MakerProductResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                // HTTP 응답 코드에 따라 처리
                switch httpResponse.statusCode {
                case 200...299:
                    // 성공적으로 데이터 받아오기
                    let response = try JSONDecoder().decode(MakerProductResponse.self, from: data)
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
    
    
    // MARK: - 분위기 가져오기
    func fetchVibes() -> AnyPublisher<Vibes, ApiError> {
        let urlString = AuthWorker.baseURL + "/vibes"
        
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
    
    
    // MARK: - 지역 가져오기
    func fetchLocations() -> AnyPublisher<MakerLocations, ApiError> {
        let urlString = AuthWorker.baseURL + "/locations"
        
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
            .decode(type: MakerLocations.self, decoder: JSONDecoder())
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
    
    
    // MARK: - 상품 등록
    func postProduct(request: MakerProductRequest) -> AnyPublisher<PostProductResponse, ApiError> {
        print("상품 request \(request)")
        let urlString = "http://34.47.94.218/snapfit/post"
        
        // Access Token이 유효한지 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        // POST할 데이터를 JSON으로 인코딩
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
        } catch {
            return Fail(error: ApiError.unknown(error)).eraseToAnyPublisher()
        }
        
        // API 호출 및 응답 처리
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case (400...499):
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 403:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Unauthorized"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                default:
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .decode(type: PostProductResponse.self, decoder: JSONDecoder())
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

    
  
    // MARK: - 이미지 경로 가져오기 (GET)
    func fetchImagePaths(ext: String = "png") -> AnyPublisher<[ImageInfoResponse.FileInfo], ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }

        let urlString = "http://34.47.94.218/snapfit/image/paths?ext=\(ext)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> [ImageInfoResponse.FileInfo] in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }

                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }

                let decodedResponse = try JSONDecoder().decode(ImageInfoResponse.self, from: data)
                return decodedResponse.fileInfos
            }
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




    // MARK: - 이미지 업로드 함수 (PUT)
    // get통해 pngpngpng 파일 페스가 올거임 구글 파일 페스에 직접 넣는덧임
    // 등록시는       "fileName": "307cf766-6145-4e33-8157-88911e43a6a1.png"
    
    func uploadImages(fileInfos: [ImageInfoResponse.FileInfo], images: [Data]) -> AnyPublisher<[String], ApiError> {
        // Access Token 확인
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // 파일 정보와 이미지 데이터를 매칭하여 PUT 요청을 생성
        let imageUploadRequests = zip(fileInfos, images).map { fileInfo, imageData -> AnyPublisher<Void, ApiError> in
            guard let url = URL(string: fileInfo.filePath) else {
                return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("image/png", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = imageData
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (_, urlResponse: URLResponse) -> Void in
                    guard let httpResponse = urlResponse as? HTTPURLResponse else {
                        throw ApiError.unknown(nil)
                    }
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                    print("Upload successful for: \(fileInfo.fileName)") // 로그 추가
                }
                .mapError { err in
                    if let apiError = err as? ApiError {
                        return apiError
                    }
                    return ApiError.unknown(nil)
                }
                .eraseToAnyPublisher()
        }
        
        // 모든 이미지 업로드 요청을 병렬로 실행하고 완료된 후 fileName를 반환
        return Publishers.MergeMany(imageUploadRequests)
            .collect()
            .map { _ in
                let filenames = fileInfos.map { $0.fileName }
                print("File names: \(filenames)") // 로그 추가
                return filenames
            }
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - 메이커 예약내역 조회

    func fetchMakerReservations(limit: Int = 10, offset: Int = 0) -> AnyPublisher<ReservationResponse, ApiError> {
        // AccessToken을 가져옴
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        // URL 문자열 생성
        let urlString = "http://34.47.94.218/snapfit/reservation/maker?limit=\(limit)&offset=\(offset)"
        
        // URL 객체 생성
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        // URL 요청 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // URLSession 데이터 태스크 퍼블리셔 사용
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> ReservationResponse in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // 응답이 성공적인 경우
                    let response = try JSONDecoder().decode(ReservationResponse.self, from: data)
                    return response
                case 400...404:
                    // 클라이언트 오류 (400-404)
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 500:
                    // 서버 오류
                    throw ApiError.serverError
                default:
                    // 기타 상태 코드 오류
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
            }
            .mapError { error in
                // 에러 매핑
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
