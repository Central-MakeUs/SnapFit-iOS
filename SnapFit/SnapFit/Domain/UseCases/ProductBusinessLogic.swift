//
//  ProductBusinessLogic.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import Foundation

// 메인프로모션 뷰, 작가리스트 뷰 같은 View들을 많이 사용
protocol ProductBusinessLogic {
    func fetchProductAll(request: MainPromotion.LoadMainPromotion.Request)
    func fetchPostDetailById(request: MainPromotion.LoadDetailProduct.Request)
    func fetchVibes()
}
