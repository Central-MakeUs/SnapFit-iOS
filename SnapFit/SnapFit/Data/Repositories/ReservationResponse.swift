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
    let id: Int? // 이게 고유값이
    let reservationTime: String?
    let post: PostDetail?
    let totalPrice: Int?
    let cancelMessage: String?
}

struct PostDetail: Codable, Identifiable {
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



