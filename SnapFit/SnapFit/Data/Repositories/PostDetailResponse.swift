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
}


struct Price: Codable {
    let min: Int?
    let price: Int?
}
