//
//  MyPageCountResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/19/24.
//

import Foundation

struct LikeCountResponse: Codable {
    let count: Int
}

struct ReservationCountResponse: Codable {
    let count: Int
}


struct UserCountCombinedResponse {
    let likeCount: Int
    let reservationCount: Int
}
