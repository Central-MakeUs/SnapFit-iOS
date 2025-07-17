//
//  MakerProductRequest.swift
//  SnapFit
//
//  Created by 정정욱 on 8/21/24.
//

import Foundation

// MARK: - MakerProductRequest
struct MakerProductRequest: Codable {
    var vibes: [String]           // 분위기 리스트
    var locations: [String]       // 위치 리스트
    var imageNames: [String]      // 이미지 파일 이름 리스트
    var thumbnail: String         // 썸네일 이미지 파일 이름
    var title: String             // 상품 제목
    var desc: String              // 상품 설명
    var prices: [Price]           // 가격 리스트 (최소 시간과 가격)
    var personPrice: Int          // 인당 추가 요금
    var studio: Bool              // 스튜디오 여부
    
    // MARK: - Price
    struct Price: Codable {
        var min: Int              // 최소 시간
        var price: Int            // 해당 시간에 대한 가격
    }

    // 생성자 (필요에 따라 기본값을 설정할 수 있음)
    init(vibes: [String], locations: [String], imageNames: [String], thumbnail: String, title: String, desc: String, prices: [Price], personPrice: Int, studio: Bool) {
        self.vibes = vibes
        self.locations = locations
        self.imageNames = imageNames
        self.thumbnail = thumbnail
        self.title = title
        self.desc = desc
        self.prices = prices
        self.personPrice = personPrice
        self.studio = studio
    }
}
