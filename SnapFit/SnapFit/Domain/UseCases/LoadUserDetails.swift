//
//  LoadUserDetails.swift
//  SnapFit
//
//  Created by MAC on 7/18/25.
//


import Foundation

enum LoadUserUseCase {
    struct Request {
        // 요청에 필요한 정보가 있다면 여기에 정의
    }
    
    struct Response {
        let userDetails: UserDetailsResponse
    }
    
    struct CountResponse {
        let userCount: UserCountCombinedResponse
    }
    
    
    struct ViewModel {
        let userDetails: UserDetailsResponse
    }
    
    struct CountViewModel {
        let userCount: UserCountCombinedResponse
    }
}
