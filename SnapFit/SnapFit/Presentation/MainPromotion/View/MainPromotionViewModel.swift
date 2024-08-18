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
    @Published var productDetail: PostDetailResponse? // 상품 디테일
    @Published var productDetailAuthorProducts: [ProductInfo] = [] // 상품 디테일에서 상품 작가가 등록한 상품들
    @Published var reservationRequest: ReservationRequest? // 예약하기 요청
    @Published var reservationSuccess: Bool?               // 예약 성공 유무
    @Published var reservationDetails : ShortTermReservationResponse? // 예약 성공 이후 상세 값 받기
    @Published var reservationproducts: [ReservationData] = [] // 예약 내역 확인하기
    
    init(productDetail: PostDetailResponse? = nil) {
        self.productDetail = productDetail
    }
}
