//
//  AuthEntity.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import Foundation

struct AuthEntity: Codable {
    let social: String?
    let vibes: [String]?
    let deviceType, fcmToken, nickName: String?
    let isMarketing: Bool?

    enum CodingKeys: String, CodingKey {
        case social, vibes
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case nickName
        case isMarketing = "is_marketing"
    }
}
