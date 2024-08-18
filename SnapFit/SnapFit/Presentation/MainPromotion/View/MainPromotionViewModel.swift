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
    @Published var reservationDetails : ReservationDetailsResponse? // 예약 성공 이후 상세 값 받기
    
    //예약 내역, 상세 정보 조회
    @Published var selectedReservationId: Int? // 어떤 예약 상품을 조회 할건지
    @Published var reservationproducts: [ReservationData] = [] // 예약 내역 확인하기
    @Published var reservationproductDetail : ReservationDetailsResponse? // 상세 조회 데이터
    
    init(productDetail: PostDetailResponse? = nil, reservationproductDetails: ReservationDetailsResponse? = nil) {
        self.productDetail = productDetail
        self.reservationproductDetail = reservationproductDetails
    }
}
