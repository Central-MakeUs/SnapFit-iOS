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
    let like: Bool
}


// 30의 1만 1시간의 2만
struct Price: Codable {
    let min: Int? // 분
    let price: Int? // 가격
}

