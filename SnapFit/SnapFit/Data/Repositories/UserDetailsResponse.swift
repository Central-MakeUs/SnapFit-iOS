//
//  UserDetailsResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/19/24.
//

import Foundation

// 사용자의 세부 정보를 정의하는 구조체
struct UserDetailsResponse: Codable {
    let id: Int?
    let nickName: String?
    let vibes: [Vibe]?
    let socialType: String?
    let profile: String?
    let marketingReceive: Bool?
    let photographer: Bool?
    let noti: Bool?
}

