//
//  ApiError.swift
//  SnapFit
//
//  Created by 정정욱 on 7/24/24.
//

import Foundation

// 커스텀 에러타입 정의
enum ApiError : Error {
    case noContent
    case decodingError
    case jsonEncoding
    case unauthorized
    case notAllowedUrl
    case badStatus(code: Int)
    case unknown(_ err: Error?)
    case invalidAccessToken
    case badRequest(message: String, errorCode: Int)
    case forbidden
    case notFound
    case serverError
    case invalidRefreshToken
    
    var info : String {
        switch self {
        case .noContent:           return "데이터가 없습니다."
        case .decodingError:       return "디코딩 에러입니다."
        case .jsonEncoding:        return "유효한 JSON 형식이 아닙니다."
        case .unauthorized:        return "인증되지 않은 사용자입니다."
        case .notAllowedUrl:       return "올바른 URL 형식이 아닙니다."
        case let .badStatus(code): return "에러 상태 코드: \(code)"
        case .unknown(let err):    return "알 수 없는 에러입니다 \n \(err?.localizedDescription ?? "")"
        case .invalidAccessToken:  return "로그인 토큰값이 비어있습니다."
        case .invalidRefreshToken: return "토큰이 만료되었거나, 올바르지 않습니다."
        case let .badRequest(message, errorCode):
                                   return "잘못된 요청입니다: \(message) (코드: \(errorCode))"
        case .forbidden:           return "접근이 금지되었습니다. (403)"
        case .notFound:            return "요청한 리소스를 찾을 수 없습니다. (404)"
        case .serverError:         return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        }
    }
}


// 서버에러 응답을 디코딩하기 위한 구조체를 추가합니다.
struct ErrorResponse: Codable {
    let message: String
    let errorCode: Int
}
