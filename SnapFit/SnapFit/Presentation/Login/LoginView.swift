//
//  LoginView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//
//
import SwiftUI
import _AuthenticationServices_SwiftUI

protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.ViewModel)
}

extension LoginView: LoginDisplayLogic {
    // 확장으로 프리젠터에서 뷰모델로 들어와 값을 변경 뷰를 바뀌 하는 부분
    func display(viewModel: Login.LoadLogin.ViewModel) {}
    func fetch() {}
}

struct LoginView: View {
    var interactor: LoginBusinessLogic?
    
    //@ObservedObject var Login = LoginDataStore()
    
    @StateObject var loginVM = LoginViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer().frame(height: 110) // Push the logo down by 110 points
                
                Group {
                    Image("appLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 141.33, height: 38.12)
                        .padding(.bottom, 10) // Add some bottom padding
                    
                    Text("나에게 맞는 사진을 만날 수 있는,")
                    Text("스냅핏에 오신걸 환영합니다!")
                }
                .foregroundColor(.white)
                .font(.title3)
                .padding(.trailing, 80)
                
                //   .frame(maxWidth: .infinity)
                Spacer()
                
                
                LoginViewGroup(loginViewModel: loginVM)
                // 애플로그인 버튼
                
                
                
                Spacer().frame(height: 110)
                
            }
            .padding(.horizontal, 15)
            .frame(width: geometry.size.width, height: geometry.size.height) // Ensure the VStack takes up the full screen
            .background(
                Image("splash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            )
        }
        .ignoresSafeArea() // Ensure the content extends to the safe area edges
        .task {
            fetch()
        }
    }
}



// MARK: - 로그인 묶음 뷰
private struct LoginViewGroup: View {
    @ObservedObject private var loginVM: LoginViewModel
    
    // fileprivate 같은 파일 내에서만 접근 가능
    fileprivate init(loginViewModel: LoginViewModel) {
        self.loginVM = loginViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            
            Image("LoginDscription")
                .resizable()
                .scaledToFill()
                .frame(width: 178, height: 22)
                .overlay {
                    HStack {
                        Image("LoginDscriptionLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 10, height: 10)
                        
                        Text("3초만에 빠른 로그인")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .offset(y: -5)  // Adjust the y-offset value as needed
                }
            
            
            // 카카오 로그인 버튼
            Button {
                // Action
                loginVM.handleKakaoLogin()
                
            } label: {
                HStack(spacing: 70) {
                    Image("kakaoButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("카카오로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(
                    Color.yellow
                    
                )
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            
            // 애플 로그인 버튼
            SignInWithAppleButton(
                onRequest: loginVM.handleAppleLogin,
                onCompletion: loginVM.handleAppleLoginCompletion
            )
            .overlay(content: {
                HStack(spacing: 70) {
                    Image("AppleButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("Apple로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(
                    Color.black
                    
                )
            })
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            // 둘러보기 버튼
            Button {
                // Action
            } label: {
                Text("둘러보기")
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.7))  // Adjust this value for a brighter gray
                    .underline()
            }
            
            
            if loginVM.isAppleLoggedIn {
                Button {
                    // Apple 로그아웃 액션
                    loginVM.handleAppleLogout()
                } label: {
                    Text("Apple 로그아웃")
                }
            }
            
            
        }
        
    }
}


private struct AppleSigninButton : View{
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        return LoginView()
    }
}
