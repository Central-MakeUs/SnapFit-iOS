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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                // Action
                loginVM.handleKakaoLogin()
                
            } label: {
                Text("카카오 로그인")
            }
            
            Button {
                // Action
                loginVM.handleKakaoLogout()
            } label: {
                Text("카카오 로그아웃")
            }
           
            SignInWithAppleButton(
                onRequest: loginVM.handleAppleLogin,
                onCompletion: loginVM.handleAppleLoginCompletion
            )
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(5)
            
            if loginVM.isAppleLoggedIn {
                Button {
                    // Apple 로그아웃 액션
                    loginVM.handleAppleLogout()
                } label: {
                    Text("Apple 로그아웃")
                }
            }
        }
        .padding()
    }
}


struct AppleSigninButton : View{
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential{
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                           // 계정 정보 가져오기
                            let UserIdentifier = appleIDCredential.user
                            let fullName = appleIDCredential.fullName
                            let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                            let email = appleIDCredential.email
                            let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                            let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(width : UIScreen.main.bounds.width * 0.9, height:50)
        .cornerRadius(5)
    }
    
}

 
#Preview {
    ContentView()
}
