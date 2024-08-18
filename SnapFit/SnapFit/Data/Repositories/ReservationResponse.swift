//
//  ReservationResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/17/24.
//

// MARK: - 사용자가 조회할때 예약 응답 구조체

struct ReservationResponse: Codable {
    let offset: Int?
    let limit: Int?
    let data: [ReservationData]?
}

struct ReservationData: Codable, Identifiable {
    let id: Int?
    let reservationTime: String?
    let post: PostDetail?
    let totalPrice: Int?
}

struct PostDetail: Codable {
    let id: Int?
    let maker: MakerDetail?
    let title: String?
    let thumbNail: String?
    let vibes: [String]?
    let locations: [String]?
    let price: Int?
    let studio: Bool?
    let like: Bool?
}

struct MakerDetail: Codable {
    let id: Int?
    let nickName: String?
}

// 예약 하고나서 바로 보여주는 모델

struct ShortTermReservationResponse: Codable {
    let id: Int
    let user: User?
    let maker: Maker?
    let post: Post?
    let reservationTime: String
    let reservationLocation: String
    let person: Int
    let personPrice: Int
    let basePrice: Int
    let totalPrice: Int
    let cancelMessage: String?
    
    struct User: Codable {
        let id: Int
        let nickName: String
    }
    
    struct Maker: Codable {
        let id: Int
        let nickName: String
    }
    
    struct Post: Codable {
        let id: Int
        let maker: Maker
        let title: String
        let thumbNail: String
        let vibes: [String]
        let locations: [String]
        let price: Int
        let studio: Bool
        let like: Bool
    }
}
