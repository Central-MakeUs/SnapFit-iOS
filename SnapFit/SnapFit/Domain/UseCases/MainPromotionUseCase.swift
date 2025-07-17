//
//  MainPromotionModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation


enum MainPromotionUseCase {
    enum LoadMainPromotion {
        
        struct Request {
            var limit: Int
            var offset: Int
        }
        
        struct VibesRequest {
            let vibes: String
        }
        
        struct Response {
            var products : Product
        }
        
        struct ViewModel {
            var products : Product
        }
        
        struct VibesPresentationViewModel { //엔터티
            let vibes: Vibes
        }
    }
    
    // 상품 디테일 조회
    enum LoadDetailProduct {
        struct Request {
            var id: Int
        }
        
        struct ProductsForMakerRequest {
            var makerid: Int
            var limit: Int
            var offset: Int
        }
    
        struct Response {
            var productDetail : PostDetailResponse
        }
        
        struct ProductsForMakerResponse {
            var products : Product
        }
        
        struct ViewModel {
            var productDetail : PostDetailResponse
        }
        
        struct ProductsForMakerViewModel {
            var products : Product
        }
    }
    
    // 예약하기
    enum ReservationProduct {
        struct Request {
            var reservationRequest: ReservationRequest
        }
        
        struct Response {
            var reservationSuccess : Bool
            var reservationDetails : ReservationDetailsResponse?
        }
        
        
        struct ViewModel {
            var reservationSuccess : Bool
            var reservationDetails : ReservationDetailsResponse?
        }
    }
    
    // 예약 내역 리스트 조회
    enum CheckReservationProducts {
        struct Request {
            var reservationRequest: ReservationRequest
        }
        
        struct Response {
            var reservationSuccess : Bool
            var reservationProducts : ReservationResponse?
        }
        
        
        struct ViewModel {
            var reservationSuccess : Bool
            var reservationProducts : ReservationResponse?
        }
    }
    
    

    
    // 예약 내역 리스트 디테일(단일) 조회
    enum CheckReservationDetailProduct {
        struct Request {
            var selectedReservationId: Int
        }
        
        struct Response {
            var reservationDetail : ReservationDetailsResponse?
        }
        
        
        struct ViewModel {
            var reservationDetail : ReservationDetailsResponse?
        }
    }
    
    // 예약내역 취소
    enum DeleteReservationProduct {
        struct Request {
            var selectedReservationId: Int
            var message: String
        }
        
        struct Response {
            var deleteReservationSuccess : Bool
        }
        
        
        struct ViewModel {
            var deleteReservationSuccess : Bool
        }
    }
    
    enum Like{
        struct Request {
            let postId: Int
        }
        
        struct LikeListRequest {
            var limit: Int
            var offset: Int
        }
        
        struct Response {
            var likeSuccess : Bool
        }
        
        struct LikeListResponse{
            var likeProducts : Product
        }
        
        struct LikeListViewModel {
            var likeProducts : Product
        }
    }
}

