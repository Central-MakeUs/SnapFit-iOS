//
//  MainPromotionModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation

enum MainPromotion {
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
    
    
    enum LoadDetailProduct {
        struct Request {
            var id: Int
        }
        
        struct Response {
            var productDetail : PostDetailResponse
        }
        
        struct ViewModel {
            var productDetail : PostDetailResponse
        }
    }
}

