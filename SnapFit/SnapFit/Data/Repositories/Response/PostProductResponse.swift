//
//  PostProductResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/21/24.
//

import Foundation
// MARK: - PostProductResponse 구조체
struct PostProductResponse: Codable {
    var id: Int
    var maker: Maker
    var createAt: String
    var thumbnail: String
    var images: [String]
    var desc: String
    var title: String
    var vibes: [String]
    var locations: [String]
    var prices: [Price]
    var personPrice: Int
    var studio: Bool
    var like: Bool
    
    struct Maker: Codable {
        var id: Int
        var nickName: String
    }
}



// MARK: - ImageInfoResponse 구조체
struct ImageInfoResponse: Codable {
    var fileInfos: [FileInfo]

    struct FileInfo: Codable {
        var fileName: String
        var filePath: String
    }
}
