//
//  kakaoAuthViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/11/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthViewModel: ObservableObject {
    
    @Published var isKakaoLogin = false
    @Published var isKakaoLogout = false
    /*
     애플로그인 플로우
     ios > 애플서버 > 응답받음(id token) > 우리 서버로 전송 - 클라
     > 우리서버에서 검증 후 access(서비스 접근 권한), refresh(토큰 만료기간 지나면 다시 접근하기 위한) token 전송 - 서버
     > 서버 다시 준 토큰 ios 에서 받고 키체인 등 저장해서
     
     토큰 검증 절차 -> 스플레시뷰에서 토큰 검증 요청해서 유요하면 메인뷰, 만료 면 리프레시토큰 가지고 엑시스 토큰 다시 만들기
     리프레시토큰도 유효하지 않았을때는 로그인화면으로
     
     근데 주의하실점은 맨 처음 로그인시에만 이름값 뽑을 수 있어요
     두번째부턴 nickname에 nil들어가요
     
     // 무무 - 토큰 보통 키체인에 저장, Or 로컬DB
     
     
     */
     
 
     
     
    func handleKakaoLogin() {
        
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            // 카카오 앱을 통해 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }else{ // 카카오톡이 설치 되어 있지 않을때
            // 카카오 웹뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                    }
                }
        }
    }
    
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }

}
