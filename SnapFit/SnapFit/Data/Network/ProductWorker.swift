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
    
    func fetchProductsFromServer(limit: Int, offset: Int) -> AnyPublisher<Products, ApiError>
}

class ProductWorker: ProductWorkingLogic {
    
    static let baseURL = "http://34.47.94.218/snapfit" // 서버 주소
    
    
    
    
    // MARK: - 메인 뷰 상품 가져오기
    func fetchProductsFromServer(limit: Int = 10, offset: Int = 0) -> AnyPublisher<Products, ApiError> {
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
            .decode(type: Products.self, decoder: JSONDecoder())
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
    
    
    
}
