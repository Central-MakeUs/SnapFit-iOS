//
//  ReservationDetailsResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/18/24.
//

import Foundation

// 예약 상세 정보를 담기 위한 구조체
struct ReservationDetailsResponse: Codable {
    let id: Int
    let user: User?
    let maker: Maker?
    let post: PostDetail?
    let reservationTime: String
    let reservationLocation: String
    let person: Int
    let personPrice: Int
    let basePrice: Int
    let totalPrice: Int
    let cancelMessage: String?
    let email : String
    let phoneNumber : String
    
    struct User: Codable {
        let id: Int
        let nickName: String
    }
    
    struct Maker: Codable {
        let id: Int
        let nickName: String
    }
    
}
