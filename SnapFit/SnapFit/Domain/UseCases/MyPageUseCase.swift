//
//  MyPageModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//  
//
import Foundation

enum MyPageUseCase {
    enum LoadMyPage {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {
            var logOut : Bool = false
        }
    }
}
