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
        
        struct Response {
            var products : Products
        }
        
        struct ViewModel {
            var products : Products
        }
    }
}

