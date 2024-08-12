import SwiftUI
import _AuthenticationServices_SwiftUI

// Presenter에서 전달 받을 기능들을 정의 UI 업데이트 관련
protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel)
    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel)
}

struct LoginView: View, LoginDisplayLogic {
    
    @ObservedObject var loginviewModel : LoginViewModel // 뷰모델 생성
    var interactor: LoginBusinessLogic?
    @State private var stack = NavigationPath() // 초기 설정
    
    // 실제 프리젠터에서 값을 받아 뷰를 업데이트하는 로직
    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel) {

        switch viewModel.socialLoginType {
        case "kakao":
            if viewModel.membershipRequired == false {
                self.loginviewModel.social = "kakao"
                self.loginviewModel.isKakaoLogin = true
                self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                self.loginviewModel.kakaoAccessToken = viewModel.kakaoAccessToken ?? ""
                print("Kakao login failed verification\(viewModel.oauthToken ?? "")")
                
            } else {
                print("Kakao login successful ")
            }
            
        case "apple":
            if viewModel.membershipRequired {
                self.loginviewModel.social = "apple"
                self.loginviewModel.isAppleLoggedIn = true
                self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                print("Apple login successful with token: \(viewModel.oauthToken ?? "")")
            } else {
                print("Apple login failed verification")
            }
            
        default:
            print("Unsupported social login type")
        }
        
        // Navigate to the appropriate view based on membership requirement
        self.loginviewModel.destination = viewModel.membershipRequired ? .splashAndTabView : .termsView
        self.loginviewModel.shouldNavigate.toggle()
        
    }
    
    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel) {
        // 이 메서드를 통해 하위뷰에 데이터를 전달할 수 있습니다.
        // 예를 들어, 하위뷰를 업데이트하거나, 하위뷰를 보여줄 수 있습니다.
        // `viewModel.vibes`를 사용하여 하위뷰를 초기화합니다.
        // 예시: `VibesView`로 데이터 전달
        self.loginviewModel.vibes = viewModel.vibes
    }
    
    var body: some View {
        NavigationStack(path: $stack) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Spacer().frame(height: 148)
                    
                    Group {
                        Image("appLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 155, height: 63)
                            .padding(.bottom, 24)
                        
                        Text("당신의 아름다운 순간을 담다.")
                            .font(.callout)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    .font(.title3)
                  
                    Spacer()
                    
                    LoginViewGroup(interactor: interactor)
                    
                    Spacer().frame(height: 32)
                }
                .padding(.horizontal, 16)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    ZStack {
                        Color.black.ignoresSafeArea()
                        Image("LoginImages")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 211, height: 426)
                            .position(x: geometry.size.width - 16 - 211 / 2, y: 224 + 426 / 2)
                    }
                )
            }
            .navigationDestination(isPresented: $loginviewModel.shouldNavigate) {
                switch loginviewModel.destination {
                case .termsView:
                    TermsView(interactor: interactor)
                        .navigationBarBackButtonHidden(true)
                case .splashAndTabView:
                    SplashAndTabView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
        .environmentObject(loginviewModel)
    }
}

private struct LoginViewGroup: View {
    var interactor: LoginBusinessLogic?
    @EnvironmentObject var viewModel: LoginViewModel // environmentObject 사용
    
    var body: some View {
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
                interactor?.loginWithKakao() // Kakao 로그인 처리
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
            
            if viewModel.isKakaoLogin {
                Button {
                    interactor?.logoutFromKakao() // Kakao 로그아웃 처리
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
                        .frame(width: 24, height: 24)
                        .padding(.leading)
                    
                    Text("Apple로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .allowsHitTesting(false)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            .padding(.bottom, 40)
            
            if viewModel.isAppleLoggedIn {
                Button {
                    // interactor?.handleAppleLogout() // Apple 로그아웃 처리
                } label: {
                    Text("애플 로그아웃")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginviewModel: LoginViewModel())
            .environmentObject(LoginViewModel())
    }
}
