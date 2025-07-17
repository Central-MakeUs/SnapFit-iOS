//
//  LoginModel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//
//
import Foundation

//use case 정의 - 로그인
enum LoginUseCase {
    enum LoadLogin {
        struct Request {
            let social: String
            let nickName: String
            let isMarketing: Bool
            let oauthToken: String
            let socialAccessToken: String
            let moods: [String]
        }
        struct Response {
            let success: Bool
            let message: String
            let tokens: Tokens?
            let error: ApiError?
        }
        struct LoginPresentationViewModel { //엔터티
            let socialLoginType: String
            let oauthToken: String?
            let socialAccessToken: String?
            let membershipRequired : Bool
        }
        struct VibesPresentationViewModel { 
            let vibes: Vibes
        }
    }
}
