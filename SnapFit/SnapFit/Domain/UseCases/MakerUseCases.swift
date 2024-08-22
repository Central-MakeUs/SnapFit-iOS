//
//  MakerUseCases.swift
//  SnapFit
//
//  Created by 정정욱 on 8/21/24.
//

import Foundation

enum MakerUseCases {
    
 
    
    // 상품 리스트 조회
    enum LoadProducts {
   
        struct ProductsForMakerRequest {
            var makerid: Int
            var limit: Int
            var offset: Int
        }
    
        
        struct ProductsForMakerResponse {
            var products : MakerProductResponse
        }
        
        
        struct ProductsForMakerViewModel {
            var products : MakerProductResponse
        }
    }
    
    enum LoadVibeAndLocation {
        
        struct VibesResponse {
            let vibes: Vibes
        }
        
        
        struct VibesViewModel { //엔터티
            let vibes: Vibes
        }
        
        struct LocationsResponse {
            let locations: MakerLocations
        }
        
        
        struct LocationsViewModel { //엔터티
            let locations: MakerLocations
        }
    }
    
    enum RequestMakerImage {
    
        
        struct ImageURLRequest {
            let Images : [Data]
        }
    
        
        struct ImageURLResponse {
            let Images: [String]
        }
    
        
        struct ImageURLViewModel { //엔터티
            let Images: [String]
        }
    }
    
    enum RequestMakerProduct {
    
        
        struct productRequest {
            let product : MakerProductRequest
        }
    
        
        struct productResponse {
            let product: PostProductResponse
        }
    
        
        struct productViewModel { //엔터티
            let product: PostProductResponse
        }
    }
    
    
    
//    // 예약 내역 리스트 조회
//    enum CheckReservationProducts {
//        struct Request {
//            var reservationRequest: ReservationRequest
//        }
//        
//        struct Response {
//            var reservationSuccess : Bool
//            var reservationProducts : ReservationResponse?
//        }
//        
//        
//        struct ViewModel {
//            var reservationSuccess : Bool
//            var reservationProducts : ReservationResponse?
//        }
//    }
//    
//    // 예약 내역 리스트 디테일(단일) 조회
//    enum CheckReservationDetailProduct {
//        struct Request {
//            var selectedReservationId: Int
//        }
//        
//        struct Response {
//            var reservationDetail : ReservationDetailsResponse?
//        }
//        
//        
//        struct ViewModel {
//            var reservationDetail : ReservationDetailsResponse?
//        }
//    }
//    
//    // 예약내역 취소
//    enum DeleteReservationProduct {
//        struct Request {
//            var selectedReservationId: Int
//            var message: String
//        }
//        
//        struct Response {
//            var deleteReservationSuccess : Bool
//        }
//        
//        
//        struct ViewModel {
//            var deleteReservationSuccess : Bool
//        }
//    }
//    
//    enum Like{
//        struct Request {
//            let postId: Int
//        }
//    }
}

