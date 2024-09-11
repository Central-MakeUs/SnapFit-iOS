//
//  Product.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//

import Foundation

// MARK: - Welcome
struct Product: Codable {
    let offset: Int
    let limit: Int
    let data: [ProductInfo]
}

struct ProductInfo: Codable, Identifiable {
    let id: Int
    let maker: Maker?
    let title: String?
    let thumbNail: String?
    let vibes: [String]?
    let locations: [String]?
    let price: Int?
    let studio: Bool?
    var like: Bool?
}

struct Maker: Codable {
    let id: Int
    let nickName: String?
}

//typealias Product = [Product]
