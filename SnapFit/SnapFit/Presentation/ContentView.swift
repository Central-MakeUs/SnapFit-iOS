//
//  ContentView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/9/24.
//
import SwiftUI
import _AuthenticationServices_SwiftUI

struct ContentView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @StateObject var loginNaviModel = LoginNavigationModel() // 독립적인 네비게이션 모델
    @State private var isLoggedIn: Bool = false // 자동 로그인 여부를 확인하기 위한 상태 변수

    var body: some View {
        VStack {
            if isLoggedIn {
                SplashAndTabView() // 토큰이 있으면 SplashAndTabView로 이동
            } else {
                Text("로그인 상태가 아닙니다.") // 실제로는 모달로 로그인 뷰를 표시할 부분입니다.
                    .hidden()
            }
        }
        .onAppear {
            //clearTokens()
            checkForSavedTokens() // 토큰 확인 로직 호출
        }
        .fullScreenCover(isPresented: $loginVM.showLoginModal) {
            LoginView(loginviewModel: loginVM, navigationModel: loginNaviModel)
                .configureView() // VIP 패턴에 맞게 뷰를 구성
                .onDisappear {
                    checkForSavedTokens() // 모달이 닫힐 때 다시 토큰을 확인
                }
        }
        .onChange(of: isLoggedIn) { newValue in
            if !newValue {
                loginVM.showLoginModal = true // 로그인 상태가 아닐 때 모달 표시
            }
        }
    }

    // 저장된 토큰이 있는지 확인하는 함수
    private func checkForSavedTokens() {
        if let _ = UserDefaults.standard.string(forKey: "accessToken"),
           let _ = UserDefaults.standard.string(forKey: "refreshToken") {
            isLoggedIn = true // 토큰이 있으면 자동 로그인으로 이동
        } else {
            isLoggedIn = false // 토큰이 없으면 로그인 화면으로 이동
            loginVM.showLoginModal = true // 로그인 모달 표시
        }
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "socialAccessToken")

        print("All tokens have been cleared from UserDefaults.")
    }
}

#Preview {
    ContentView()
}
