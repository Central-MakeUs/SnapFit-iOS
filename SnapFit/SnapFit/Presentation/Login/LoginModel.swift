//
//  LoginModel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import Foundation

//use case 정의 - 로그인
enum Login {
    enum LoadLogin {
        struct Request { // 애플로그인, 카카오 로그인을 구분하기 위한 요청 - worker 사용해야함
            var loginType: String
        }
        struct Response { // 각 소셜로그인에 대한 요청 처리 이후, 실 서버에 전달 이후 토큰 값 가져오기
            var token: String
        }
        
        struct ViewModel {} // 토큰 값을 가지고 인증 처리시 mainView로 이전시켜야함
    }
}
