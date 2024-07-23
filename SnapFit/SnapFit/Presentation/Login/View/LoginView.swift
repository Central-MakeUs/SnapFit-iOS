//
//  LoginView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//
//
import SwiftUI
import _AuthenticationServices_SwiftUI


// Presenter에서 전달 받을 기능들을 정의 UI 업데이트 관현 
protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.ViewModel)
}

struct LoginView: View, LoginDisplayLogic {
    
    // 실제 프리젠터에서 값을 받아 뷰를 업데이트하는 로직
    func display(viewModel: Login.LoadLogin.ViewModel) {
        self.viewModel.loginMessage = viewModel.message
        if viewModel.success {
            if viewModel.message.contains("Kakao login successful") {
                self.viewModel.social = "kakao"
                print("viewModel.social \(self.viewModel.social)")
                self.viewModel.isKakaoLogin = true
                self.viewModel.shouldNavigate.toggle()
                print("shouldNavigate \(self.viewModel.shouldNavigate)")
            }
            else if viewModel.message.contains("Kakao logout successful") {
                self.viewModel.isKakaoLogin = false
            }
            else if viewModel.message.contains("Apple login successful") {
                self.viewModel.social = "APPLE"
                self.viewModel.isAppleLoggedIn = true
                self.viewModel.shouldNavigate.toggle()
                print("viewModel.social \(self.viewModel.social)")
                print("shouldNavigate \(self.viewModel.shouldNavigate)")
                
            } else if viewModel.message.contains("Apple logout successful") {
                self.viewModel.isAppleLoggedIn = false
            }
        }
    }
    
    /*
     위치 대신에 분위기만
     카드 UI 동일
     */
    
    @ObservedObject var viewModel: LoginViewModel
    var interactor: LoginBusinessLogic?
    
    @State var stack = NavigationPath() // 초기 설정
    
    var body: some View {
        NavigationStack(path: $stack) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Spacer().frame(height: 110)
                    
                    Group {
                        Image("appLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 141.33, height: 38.12)
                            .padding(.bottom, 10)
                        
                        Text("나에게 맞는 사진을 만날 수 있는,")
                        Text("스냅핏에 오신걸 환영합니다!")
                    }
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.trailing, 80)
                    
                    Spacer()
                    
                    LoginViewGroup(interactor: interactor, viewModel: viewModel)
                    
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 15)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    Image("splash")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                )
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                TermsView(viewModel: viewModel, interactor: interactor)
                    .navigationBarBackButtonHidden(true)
            }
            .ignoresSafeArea()
            .task {
                //interactor?.load(request: Login.LoadLogin.Request())
            }
//            .alert(isPresented: Binding<Bool>(get: {
//                !viewModel.loginMessage.isEmpty
//            }, set: { _ in })) {
//                Alert(title: Text("Login"), message: Text(viewModel.loginMessage), dismissButton: .default(Text("OK")))
//            }
            .onAppear {
                //interactor?.load(request: Login.LoadLogin.Request())
                
            }
          
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
  

}

private struct LoginViewGroup: View {
    private var interactor: LoginBusinessLogic?
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(interactor: LoginBusinessLogic?, viewModel: LoginViewModel) {
        self.interactor = interactor
        self.viewModel = viewModel
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
                    .offset(y: -7)
                }
            
            Button {
                interactor?.handleKakaoLogin()
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
                .background(Color.yellow)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            // 카카오 로그아웃 버튼
            if viewModel.isKakaoLogin {
                Button {
                    interactor?.handleKakaoLogout()
                } label: {
                    Text("카카오 로그아웃")
                }
            }
            
            
            
            SignInWithAppleButton(
                onRequest: { request in interactor?.handleAppleLogin(request: request) },
                onCompletion: { result in interactor?.handleAppleLoginCompletion(result: result) }
            )
            .overlay {
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
                .background(Color.black)
                .allowsHitTesting(false)  // 터치 이벤트를 허용하지 않음
                // 오버레이를 사용하되 터치 이벤트를 하위뷰로 전달할 수 있음
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            
            // Apple 로그아웃 버튼
            if viewModel.isAppleLoggedIn {
                Button {
                    interactor?.handleAppleLogout()
                } label: {
                    Text("애플 로그아웃")
                }
            }
            
            Button {
                // Action for "둘러보기"
            } label: {
                Text("둘러보기")
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.7))
                    .underline()
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
        return LoginView(viewModel: LoginViewModel(), interactor: nil)
    }
}
