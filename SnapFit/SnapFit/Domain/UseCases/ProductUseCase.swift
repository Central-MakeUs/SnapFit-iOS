//
//  ProductBusinessLogic.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import Foundation

// 메인프로모션 뷰, 작가리스트 뷰 같은 View들을 많이 사용
protocol ProductUseCase {
    func fetchProductAll(request: MainPromotionUseCase.LoadMainPromotion.Request)
    func fetchPostDetailById(request: MainPromotionUseCase.LoadDetailProduct.Request)
    func fetchProductsForMaker(request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest)
    func fetchVibes()
    
    
    // MARK: - 상품 예약관련
    func makeReservation(request: MainPromotionUseCase.ReservationProduct.Request)
    func fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request)
    func fetchReservationDetail(request: MainPromotionUseCase.CheckReservationDetailProduct.Request)
    func deleteReservation(request: MainPromotionUseCase.DeleteReservationProduct.Request)
    
    // 상품 찜하기, 취소
    func likePost(request: MainPromotionUseCase.Like.Request)
    func unlikePost(request: MainPromotionUseCase.Like.Request)
}
