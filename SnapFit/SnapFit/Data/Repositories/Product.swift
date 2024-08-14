//
//  Product.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//

import Foundation

// MARK: - Welcome
struct Product: Codable {
    let offset, limit: Int?
    let data: [ProductInfo]?
}

// MARK: - Datum
struct ProductInfo: Codable {
    let id: Int?
    let maker: Maker?
    let title, thumbNail: String?
    let vibes, locations: [String]?
    let price: Int?
    let studio: Bool?
}

// MARK: - Maker
struct Maker: Codable {
    let id: Int?
    let nickName: String?
}

typealias Products = [Product]
