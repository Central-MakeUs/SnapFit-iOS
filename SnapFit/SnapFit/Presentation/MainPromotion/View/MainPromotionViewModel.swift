//
//  MainPromotionViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//

import Foundation

class MainPromotionViewModel: NSObject, ObservableObject {


    @Published var vibes: [Vibe] = []
    @Published var products: [ProductInfo] = []
    @Published var selectedProductId: Int?
    @Published var productDetail: PostDetailResponse?
    
    init(productDetail: PostDetailResponse? = nil) {
        self.productDetail = productDetail
    }
}
