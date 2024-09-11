//
//  MakerProductResponse.swift
//  SnapFit
//
//  Created by 정정욱 on 8/21/24.
//

import Foundation

struct MakerProductResponse: Codable {
    let offset: Int?
    let limit: Int?
    let data: [PostDetail]?
}


