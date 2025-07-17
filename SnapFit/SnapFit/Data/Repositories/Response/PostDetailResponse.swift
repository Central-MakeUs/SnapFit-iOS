//
//  PostDetailResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//

import Foundation

struct PostDetailResponse: Codable {
    let id: Int
    let maker: Maker?
    let createAt: String?
    let thumbnail: String?
    let images: [String]?
    let desc: String?
    let title: String?
    let vibes: [String]?
    let locations: [String]?
    let prices: [Price]?
    let personPrice: Int?
    let studio: Bool?
    let like: Bool
}


// 30의 1만 1시간의 2만
struct Price: Codable {
    let min: Int? // 분
    let price: Int? // 가격
}


//// 상품 등록

struct PostPrice: Identifiable {
    let id = UUID() // Identifiable 프로토콜 준수를 위해 ID 추가
    let minutes: Int
    let price: Int
    
    // 분을 문자열로 변환하는 계산 프로퍼티
    var time: String {
        let hours = minutes / 60
        let minutesPart = minutes % 60
        
        var timeString = ""
        if hours > 0 {
            timeString += "\(hours)시간 "
        }
        if minutesPart > 0 || hours == 0 { // 분이 0이 아니거나 시간도 없을 경우 표시
            timeString += "\(minutesPart)분"
        }
        
        return timeString
    }
}
