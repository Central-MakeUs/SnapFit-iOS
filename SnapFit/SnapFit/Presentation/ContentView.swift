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
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Button {
//                // Action
//                loginVM.handleKakaoLogin()
//                
//            } label: {
//                Text("카카오 로그인")
//            }
//            
//            Button {
//                // Action
//                loginVM.handleKakaoLogout()
//            } label: {
//                Text("카카오 로그아웃")
//            }
//           
//            SignInWithAppleButton(
//                onRequest: loginVM.handleAppleLogin,
//                onCompletion: loginVM.handleAppleLoginCompletion
//            )
//            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
//            .cornerRadius(5)
//            
//            if loginVM.isAppleLoggedIn {
//                Button {
//                    // Apple 로그아웃 액션
//                    loginVM.handleAppleLogout()
//                } label: {
//                    Text("Apple 로그아웃")
//                }
//            }
            
            LoginView(viewModel: loginVM).configureView()
        }

    }
}



 
#Preview {
    ContentView()
}
